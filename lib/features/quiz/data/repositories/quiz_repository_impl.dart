import 'dart:math';

import '../../../../core/db/app_database.dart';
import '../../../question/data/datasources/question_local_datasource.dart';
import '../../../question/data/mapper/question_mapper.dart';
import '../../domain/constants/exam_distribution.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_local_datasource.dart';
import '../mappers/quiz_mapper.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizLocalDataSource _quizDataSource;
  final QuestionLocalDataSource _questionDataSource;
  final QuizMapper _quizMapper;
  final QuestionMapper _questionMapper;

  QuizRepositoryImpl(
    this._quizDataSource,
    this._questionDataSource,
    this._quizMapper,
    this._questionMapper,
  );

  @override
  Future<Quiz> createQuiz({
    required QuizType type,
    int? examSheetIndex,
    List<int>? customQuestionIds,
  }) async {
    final quizId = DateTime.now().millisecondsSinceEpoch.toString();
    final now = DateTime.now();

    // Get question IDs based on quiz type
    final List<int> questionIds;
    if (type == QuizType.custom && customQuestionIds != null) {
      questionIds = customQuestionIds;
    } else if (examSheetIndex != null) {
      questionIds = _getQuestionIdsForExam(type, examSheetIndex);
    } else {
      // Random exam sheet
      final randomIndex = Random().nextInt(15);
      questionIds = _getQuestionIdsForExam(type, randomIndex);
    }

    // Fetch questions from database
    // final questions = await _questionDataSource.getQuestionsPaginated(
    //    limit: 1000,
    //    offset: 0,
    //  );

 // this method applied for better performance
    final questions = await _questionDataSource.getQuestionsByIds(
        ids: questionIds
    );

    final questionMap = {for (var q in questions) q.id: q};

    // Calculate total points and create quiz questions
    int totalPoints = 0;
    final quizQuestions = <QuizQuestionsCompanion>[];
    final random = Random();

    for (int i = 0; i < questionIds.length; i++) {
      final questionId = questionIds[i];
      final question = questionMap[questionId];

      if (question != null) {
        final mappedQuestion = _questionMapper.fromDbRow(question);
        totalPoints += mappedQuestion.points;

        // Shuffle answer IDs
        final answerIds =
            mappedQuestion.answers.map((a) => a.id).toList()..shuffle(random);

        quizQuestions.add(
          QuizQuestionsCompanionBuilder.create(
            quizId: quizId,
            questionId: questionId,
            orderIndex: i,
            shuffledAnswerIds: answerIds,
            points: mappedQuestion.points,
          ),
        );
      }
    }

    // Insert quiz
    await _quizDataSource.insertQuiz(
      id: quizId,
      quizType: _quizMapper.quizTypeToString(type),
      examSheetIndex: examSheetIndex,
      startedAt: now,
      totalQuestions: quizQuestions.length,
      totalPoints: totalPoints,
    );

    // Insert quiz questions
    await _quizDataSource.insertQuizQuestions(quizQuestions);

    // Return the created quiz
    final createdQuiz = await getQuizById(quizId);
    return createdQuiz!;
  }

  List<int> _getQuestionIdsForExam(QuizType type, int index) {
    switch (type) {
      case QuizType.motor:
        return ExamDistribution.getMotorExam(index);
      case QuizType.sailingOnly:
        return ExamDistribution.getSailingOnlyExam(index);
      case QuizType.combined:
        return ExamDistribution.getCombinedExam(index);
      case QuizType.custom:
        return [];
    }
  }

  @override
  Future<Quiz?> getQuizById(String id) async {
    final quizRow = await _quizDataSource.getQuizById(id);
    if (quizRow == null) return null;

    final questionRows = await _quizDataSource.getQuizQuestionsById(id);
    return _quizMapper.fromDbRows(quizRow, questionRows);
  }

  @override
  Future<void> submitAnswer({
    required String quizId,
    required int questionId,
    required String selectedAnswerId,
    required bool wasCorrect,
  }) {
    return _quizDataSource.updateAnswer(
      quizId: quizId,
      questionId: questionId,
      selectedAnswerId: selectedAnswerId,
      wasCorrect: wasCorrect,
      answeredAt: DateTime.now(),
    );
  }

  @override
  Future<void> updateCurrentIndex(String quizId, int index) {
    return _quizDataSource.updateCurrentIndex(quizId, index);
  }

  @override
  Future<QuizResult> completeQuiz(String quizId) async {
    final quiz = await getQuizById(quizId);
    if (quiz == null) {
      throw Exception('Quiz not found: $quizId');
    }

    final endedAt = DateTime.now();
    final correctAnswers = quiz.correctCount;
    final earnedPoints = quiz.earnedPoints;

    // Get question categories for pass/fail calculation
    final questionIds = quiz.questions.map((q) => q.questionId).toList();
    final questionRows = await _questionDataSource.getQuestionsPaginated(
      limit: 1000,
      offset: 0,
    );

    // Build category map for questions
    final questionCategories = <int, String>{};
    for (final row in questionRows) {
      if (questionIds.contains(row.id)) {
        questionCategories[row.id] = row.categoryId;
      }
    }

    // Calculate results by category
    final categoryResults = _calculateCategoryResults(
      quiz: quiz,
      questionCategories: questionCategories,
    );

    // Determine pass/fail based on quiz type and category rules
    final passed = _calculatePassed(quiz.type, categoryResults);

    await _quizDataSource.updateQuizCompletion(
      quizId: quizId,
      endedAt: endedAt,
      correctAnswers: correctAnswers,
      earnedPoints: earnedPoints,
      passed: passed,
    );

    // Return result
    final duration = endedAt.difference(quiz.startedAt);
    return QuizResult(
      quizType: quiz.type,
      totalQuestions: quiz.totalQuestions,
      correctAnswers: correctAnswers,
      totalPoints: quiz.totalPoints,
      earnedPoints: earnedPoints,
      duration: duration,
      passed: passed,
      categoryResults: categoryResults,
    );
  }

  List<CategoryResult> _calculateCategoryResults({
    required Quiz quiz,
    required Map<int, String> questionCategories,
  }) {
    // Count correct answers per category
    final categoryStats = <String, _CategoryStats>{};

    for (final question in quiz.questions) {
      final categoryId = questionCategories[question.questionId] ?? 'unknown';
      categoryStats.putIfAbsent(
        categoryId,
        () => _CategoryStats(categoryId),
      );
      categoryStats[categoryId]!.total++;
      if (question.wasCorrect == true) {
        categoryStats[categoryId]!.correct++;
      }
    }

    // Build category results with pass rules
    final results = <CategoryResult>[];

    for (final entry in categoryStats.entries) {
      final stats = entry.value;
      final required = _getRequiredCorrect(quiz.type, stats.categoryId, stats.total);

      results.add(CategoryResult(
        categoryId: stats.categoryId,
        categoryName: _getCategoryName(stats.categoryId),
        totalQuestions: stats.total,
        correctAnswers: stats.correct,
        requiredCorrect: required,
        passed: stats.correct >= required,
      ));
    }

    return results;
  }

  int _getRequiredCorrect(QuizType quizType, String categoryId, int total) {
    switch (quizType) {
      case QuizType.motor:
        if (categoryId == 'basisfragen') {
          return ExamPassRules.motorBasisRequired; // 5 of 7
        } else {
          return ExamPassRules.motorSpecificRequired; // 18 of 23
        }

      case QuizType.sailingOnly:
        if (categoryId == 'basisfragen') {
          return ExamPassRules.sailingBasisRequired; // 5 of 7
        } else {
          return ExamPassRules.sailingSpecificRequired; // 14 of 18
        }

      case QuizType.combined:
        if (categoryId == 'basisfragen') {
          return ExamPassRules.motorBasisRequired; // 5 of 7
        } else if (categoryId == 'spezifisch_binnen') {
          return ExamPassRules.motorSpecificRequired; // 18 of 23
        } else {
          return ExamPassRules.combinedSailingSupplementRequired; // 5 of 7
        }

      case QuizType.custom:
        // For custom quizzes, use 70% per category
        return (total * ExamPassRules.customPassPercentage).ceil();
    }
  }

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case 'basisfragen':
        return 'Basisfragen';
      case 'spezifisch_binnen':
        return 'Spezifisch Binnen';
      case 'spezifisch_segeln':
        return 'Spezifisch Segeln';
      default:
        return categoryId;
    }
  }

  bool _calculatePassed(QuizType quizType, List<CategoryResult> categoryResults) {
    if (categoryResults.isEmpty) return false;

    // For all quiz types: must pass ALL categories
    return categoryResults.every((c) => c.passed);
  }

  @override
  Future<void> abandonQuiz(String quizId) {
    return _quizDataSource.updateQuizStatus(quizId, 'abandoned');
  }

  @override
  Future<List<Quiz>> getQuizHistory({
    QuizType? type,
    int? limit,
    int? offset,
  }) async {
    final typeString = type != null ? _quizMapper.quizTypeToString(type) : null;
    final quizRows = await _quizDataSource.getQuizHistory(
      type: typeString,
      limit: limit,
      offset: offset,
    );

    final quizzes = <Quiz>[];
    for (final quizRow in quizRows) {
      final questionRows =
          await _quizDataSource.getQuizQuestionsById(quizRow.id);
      quizzes.add(_quizMapper.fromDbRows(quizRow, questionRows));
    }

    return quizzes;
  }

  @override
  Future<List<Quiz>> getResumableQuizzes() async {
    final quizRows = await _quizDataSource.getResumableQuizzes();

    final quizzes = <Quiz>[];
    for (final quizRow in quizRows) {
      final questionRows =
          await _quizDataSource.getQuizQuestionsById(quizRow.id);
      quizzes.add(_quizMapper.fromDbRows(quizRow, questionRows));
    }

    return quizzes;
  }

  @override
  Stream<List<Quiz>> watchQuizHistory({int? limit}) {
    return _quizDataSource.watchQuizHistory(limit: limit).asyncMap(
      (quizRows) async {
        final quizzes = <Quiz>[];
        for (final quizRow in quizRows) {
          final questionRows =
              await _quizDataSource.getQuizQuestionsById(quizRow.id);
          quizzes.add(_quizMapper.fromDbRows(quizRow, questionRows));
        }
        return quizzes;
      },
    );
  }

  @override
  Stream<List<Quiz>> watchOpenQuizzes({int? limit}) {
    return _quizDataSource.watchOpenQuizzes(limit: limit).asyncMap(
      (quizRows) async {
        final quizzes = <Quiz>[];
        for (final quizRow in quizRows) {
          final questionRows =
              await _quizDataSource.getQuizQuestionsById(quizRow.id);
          quizzes.add(_quizMapper.fromDbRows(quizRow, questionRows));
        }
        return quizzes;
      },
    );
  }

  @override
  Stream<List<Quiz>> watchCompletedQuizzes({int? limit}) {
    return _quizDataSource.watchCompletedQuizzes(limit: limit).asyncMap(
      (quizRows) async {
        final quizzes = <Quiz>[];
        for (final quizRow in quizRows) {
          final questionRows =
              await _quizDataSource.getQuizQuestionsById(quizRow.id);
          quizzes.add(_quizMapper.fromDbRows(quizRow, questionRows));
        }
        return quizzes;
      },
    );
  }

  @override
  Future<void> deleteQuiz(String quizId) {
    return _quizDataSource.deleteQuiz(quizId);
  }
}

/// Helper class to track category statistics
class _CategoryStats {
  final String categoryId;
  int total = 0;
  int correct = 0;

  _CategoryStats(this.categoryId);
}
