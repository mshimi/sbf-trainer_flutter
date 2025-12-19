import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../../core/db/app_database.dart';
import '../../domain/entities/question.dart' as entity;

abstract class QuestionLocalDataSource {
  Future<bool> hasQuestions();
  Future<void> insertQuestionsWithRankings(List<entity.Question> questions);
  Future<int> getQuestionCount();
  Future<int> getRankingCount();
  Future<int> getMasteredQuestionCount(int threshold);
  Stream<int> watchQuestionCount();
  Stream<int> watchMasteredQuestionCount(int threshold);
  Future<List<Question>> getQuestionsPaginated({
    required int limit,
    required int offset,
    List<String>? categoryIds,
  });
  Future<int> getQuestionCountByCategories(List<String>? categoryIds);
  Future<Map<int, int>> getRankingsForQuestions(List<int> questionIds);
  Future<void> updateRanking({
    required int questionId,
    required bool wasCorrect,
  });
  Future<List<int>> getRandomQuestionIds({
    required int count,
    List<String>? categoryIds,
  });
}

class QuestionLocalDataSourceImpl implements QuestionLocalDataSource {
  final AppDatabase _db;

  QuestionLocalDataSourceImpl(this._db);

  @override
  Future<bool> hasQuestions() async {
    final count = await _db.questions.count().getSingle();
    return count > 0;
  }

  @override
  Future<void> insertQuestionsWithRankings(List<entity.Question> questions) async {
    await _db.batch((batch) {
      for (final question in questions) {
        batch.insert(
          _db.questions,
          QuestionsCompanion.insert(
            id: Value(question.id),
            categoryId: question.categoryId,
            questionText: question.questionText,
            points: question.points,
            hasImages: Value(question.hasImages),
            imageRefsJson: Value(jsonEncode(question.imageRefs)),
            answersJson: Value(jsonEncode(
              question.answers
                  .map((a) => {
                        'id': a.id,
                        'text': a.text,
                        'is_correct': a.isCorrect,
                      })
                  .toList(),
            )),
          ),
        );

        batch.insert(
          _db.questionRankings,
          QuestionRankingsCompanion.insert(
            questionId: Value(question.id),
          ),
        );
      }
    });
  }

  @override
  Future<int> getQuestionCount() {
    return _db.questions.count().getSingle();
  }

  @override
  Future<int> getRankingCount() {
    return _db.questionRankings.count().getSingle();
  }

  @override
  Future<int> getMasteredQuestionCount(int threshold) {
    return (_db.selectOnly(_db.questionRankings)
          ..addColumns([_db.questionRankings.questionId])
          ..where(_db.questionRankings.timesCorrect.isBiggerOrEqualValue(threshold)))
        .get()
        .then((rows) => rows.length);
  }

  @override
  Stream<int> watchQuestionCount() {
    return _db.questions.count().watchSingle();
  }

  @override
  Stream<int> watchMasteredQuestionCount(int threshold) {
    return (_db.selectOnly(_db.questionRankings)
          ..addColumns([_db.questionRankings.questionId])
          ..where(_db.questionRankings.timesCorrect.isBiggerOrEqualValue(threshold)))
        .watch()
        .map((rows) => rows.length);
  }

  @override
  Future<List<Question>> getQuestionsPaginated({
    required int limit,
    required int offset,
    List<String>? categoryIds,
  }) async {
    final query = _db.select(_db.questions);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      query.where((q) => q.categoryId.isIn(categoryIds));
    }

    query
      ..orderBy([(q) => OrderingTerm.asc(q.id)])
      ..limit(limit, offset: offset);

    return query.get();
  }

  @override
  Future<int> getQuestionCountByCategories(List<String>? categoryIds) async {
    if (categoryIds == null || categoryIds.isEmpty) {
      return _db.questions.count().getSingle();
    }

    final query = _db.selectOnly(_db.questions)
      ..addColumns([_db.questions.id.count()])
      ..where(_db.questions.categoryId.isIn(categoryIds));

    final result = await query.getSingle();
    return result.read(_db.questions.id.count()) ?? 0;
  }

  @override
  Future<Map<int, int>> getRankingsForQuestions(List<int> questionIds) async {
    if (questionIds.isEmpty) return {};

    final query = _db.select(_db.questionRankings)
      ..where((r) => r.questionId.isIn(questionIds));

    final results = await query.get();
    return {for (final r in results) r.questionId: r.timesCorrect};
  }

  @override
  Future<void> updateRanking({
    required int questionId,
    required bool wasCorrect,
  }) async {
    if (wasCorrect) {
      // Increment timesCorrect by 1
      await (_db.update(_db.questionRankings)
            ..where((r) => r.questionId.equals(questionId)))
          .write(
        QuestionRankingsCompanion.custom(
          timesCorrect: _db.questionRankings.timesCorrect + const Constant(1),
        ),
      );
    } else {
      // Reset timesCorrect to 0
      await (_db.update(_db.questionRankings)
            ..where((r) => r.questionId.equals(questionId)))
          .write(
        const QuestionRankingsCompanion(
          timesCorrect: Value(0),
        ),
      );
    }
  }

  @override
  Future<List<int>> getRandomQuestionIds({
    required int count,
    List<String>? categoryIds,
  }) async {
    // Use SQL RANDOM() to get random questions
    final query = _db.selectOnly(_db.questions)
      ..addColumns([_db.questions.id]);

    if (categoryIds != null && categoryIds.isNotEmpty) {
      query.where(_db.questions.categoryId.isIn(categoryIds));
    }

    // Order by random and limit
    query
      ..orderBy([OrderingTerm.random()])
      ..limit(count);

    final results = await query.get();
    return results.map((row) => row.read(_db.questions.id)!).toList();
  }
}
