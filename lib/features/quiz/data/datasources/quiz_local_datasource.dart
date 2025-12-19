import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';

abstract class QuizLocalDataSource {
  Future<void> insertQuiz({
    required String id,
    required String quizType,
    int? examSheetIndex,
    required DateTime startedAt,
    required int totalQuestions,
    required int totalPoints,
  });

  Future<void> insertQuizQuestions(List<QuizQuestionsCompanion> questions);

  Future<Quizze?> getQuizById(String id);

  Future<List<QuizQuestion>> getQuizQuestionsById(String quizId);

  Future<void> updateAnswer({
    required String quizId,
    required int questionId,
    required String selectedAnswerId,
    required bool wasCorrect,
    required DateTime answeredAt,
  });

  Future<void> updateCurrentIndex(String quizId, int index);

  Future<void> updateQuizCompletion({
    required String quizId,
    required DateTime endedAt,
    required int correctAnswers,
    required int earnedPoints,
    required bool passed,
  });

  Future<void> updateQuizStatus(String quizId, String status);

  Future<List<Quizze>> getQuizHistory({
    String? type,
    int? limit,
    int? offset,
  });

  Future<List<Quizze>> getResumableQuizzes();

  Stream<List<Quizze>> watchQuizHistory({int? limit});

  Stream<List<Quizze>> watchOpenQuizzes({int? limit});

  Stream<List<Quizze>> watchCompletedQuizzes({int? limit});

  Future<void> deleteQuiz(String quizId);
}

class QuizLocalDataSourceImpl implements QuizLocalDataSource {
  final AppDatabase _db;

  QuizLocalDataSourceImpl(this._db);

  @override
  Future<void> insertQuiz({
    required String id,
    required String quizType,
    int? examSheetIndex,
    required DateTime startedAt,
    required int totalQuestions,
    required int totalPoints,
  }) async {
    await _db.into(_db.quizzes).insert(
          QuizzesCompanion.insert(
            id: id,
            quizType: quizType,
            examSheetIndex: Value(examSheetIndex),
            startedAt: startedAt,
            totalQuestions: totalQuestions,
            totalPoints: Value(totalPoints),
          ),
        );
  }

  @override
  Future<void> insertQuizQuestions(List<QuizQuestionsCompanion> questions) {
    return _db.batch((batch) {
      batch.insertAll(_db.quizQuestions, questions);
    });
  }

  @override
  Future<Quizze?> getQuizById(String id) {
    return (_db.select(_db.quizzes)..where((q) => q.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Future<List<QuizQuestion>> getQuizQuestionsById(String quizId) {
    return (_db.select(_db.quizQuestions)
          ..where((q) => q.quizId.equals(quizId))
          ..orderBy([(q) => OrderingTerm.asc(q.orderIndex)]))
        .get();
  }

  @override
  Future<void> updateAnswer({
    required String quizId,
    required int questionId,
    required String selectedAnswerId,
    required bool wasCorrect,
    required DateTime answeredAt,
  }) {
    return (_db.update(_db.quizQuestions)
          ..where(
              (q) => q.quizId.equals(quizId) & q.questionId.equals(questionId)))
        .write(
      QuizQuestionsCompanion(
        selectedAnswerId: Value(selectedAnswerId),
        wasCorrect: Value(wasCorrect),
        answeredAt: Value(answeredAt),
      ),
    );
  }

  @override
  Future<void> updateCurrentIndex(String quizId, int index) {
    return (_db.update(_db.quizzes)..where((q) => q.id.equals(quizId))).write(
      QuizzesCompanion(currentQuestionIndex: Value(index)),
    );
  }

  @override
  Future<void> updateQuizCompletion({
    required String quizId,
    required DateTime endedAt,
    required int correctAnswers,
    required int earnedPoints,
    required bool passed,
  }) {
    return (_db.update(_db.quizzes)..where((q) => q.id.equals(quizId))).write(
      QuizzesCompanion(
        endedAt: Value(endedAt),
        status: const Value('completed'),
        correctAnswers: Value(correctAnswers),
        earnedPoints: Value(earnedPoints),
        passed: Value(passed),
      ),
    );
  }

  @override
  Future<void> updateQuizStatus(String quizId, String status) {
    return (_db.update(_db.quizzes)..where((q) => q.id.equals(quizId))).write(
      QuizzesCompanion(status: Value(status)),
    );
  }

  @override
  Future<List<Quizze>> getQuizHistory({
    String? type,
    int? limit,
    int? offset,
  }) {
    final query = _db.select(_db.quizzes);

    if (type != null) {
      query.where((q) => q.quizType.equals(type));
    }

    query.orderBy([(q) => OrderingTerm.desc(q.startedAt)]);

    if (limit != null) {
      query.limit(limit, offset: offset ?? 0);
    }

    return query.get();
  }

  @override
  Future<List<Quizze>> getResumableQuizzes() {
    return (_db.select(_db.quizzes)
          ..where((q) => q.status.equals('in_progress'))
          ..orderBy([(q) => OrderingTerm.desc(q.startedAt)]))
        .get();
  }

  @override
  Stream<List<Quizze>> watchQuizHistory({int? limit}) {
    final query = _db.select(_db.quizzes)
      ..orderBy([(q) => OrderingTerm.desc(q.startedAt)]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  @override
  Stream<List<Quizze>> watchOpenQuizzes({int? limit}) {
    final query = _db.select(_db.quizzes)
      ..where((q) => q.status.equals('in_progress'))
      ..orderBy([(q) => OrderingTerm.desc(q.startedAt)]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  @override
  Stream<List<Quizze>> watchCompletedQuizzes({int? limit}) {
    final query = _db.select(_db.quizzes)
      ..where((q) =>
          q.status.equals('completed') | q.status.equals('abandoned'))
      ..orderBy([(q) => OrderingTerm.desc(q.startedAt)]);

    if (limit != null) {
      query.limit(limit);
    }

    return query.watch();
  }

  @override
  Future<void> deleteQuiz(String quizId) async {
    await (_db.delete(_db.quizQuestions)
          ..where((q) => q.quizId.equals(quizId)))
        .go();
    await (_db.delete(_db.quizzes)..where((q) => q.id.equals(quizId))).go();
  }
}

extension QuizQuestionsCompanionBuilder on QuizQuestionsCompanion {
  static QuizQuestionsCompanion create({
    required String quizId,
    required int questionId,
    required int orderIndex,
    required List<String> shuffledAnswerIds,
    required int points,
  }) {
    return QuizQuestionsCompanion.insert(
      quizId: quizId,
      questionId: questionId,
      orderIndex: orderIndex,
      shuffledAnswerIdsJson: jsonEncode(shuffledAnswerIds),
      points: points,
    );
  }
}
