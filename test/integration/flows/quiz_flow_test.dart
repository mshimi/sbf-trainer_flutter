import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/core/db/app_database.dart';
import 'package:sbf_trainer/features/question/data/datasources/question_local_datasource.dart';
import 'package:sbf_trainer/features/question/data/mapper/question_mapper.dart';
import 'package:sbf_trainer/features/question/data/repositories/question_repository_impl.dart';
import 'package:sbf_trainer/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:sbf_trainer/features/quiz/data/mappers/quiz_mapper.dart';
import 'package:sbf_trainer/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';

void main() {
  late AppDatabase db;
  late QuizRepositoryImpl quizRepository;
  late QuestionRepositoryImpl questionRepository;
  late QuestionLocalDataSourceImpl questionDataSource;
  late QuizLocalDataSourceImpl quizDataSource;

  Future<void> seedTestQuestions() async {
    // Seed 37 questions for combined exam testing
    // 7 basisfragen (1-7)
    // 23 spezifischbinnen (8-30)
    // 7 ergaenzungsegeln (31-37)
    for (int i = 1; i <= 37; i++) {
      String categoryId;
      if (i <= 7) {
        categoryId = 'basisfragen';
      } else if (i <= 30) {
        categoryId = 'spezifischbinnen';
      } else {
        categoryId = 'ergaenzungsegeln';
      }

      await db.into(db.questions).insert(QuestionsCompanion.insert(
            id: Value(i),
            categoryId: categoryId,
            questionText: 'Question $i?',
            points: 1,
            answersJson: Value(jsonEncode([
              {'id': 'a1', 'text': 'Correct', 'is_correct': true},
              {'id': 'a2', 'text': 'Wrong 1', 'is_correct': false},
              {'id': 'a3', 'text': 'Wrong 2', 'is_correct': false},
              {'id': 'a4', 'text': 'Wrong 3', 'is_correct': false},
            ])),
          ));
      await db.into(db.questionRankings).insert(
            QuestionRankingsCompanion.insert(
              questionId: Value(i),
              timesCorrect: const Value(0),
            ),
          );
    }
  }

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    questionDataSource = QuestionLocalDataSourceImpl(db);
    quizDataSource = QuizLocalDataSourceImpl(db);

    questionRepository = QuestionRepositoryImpl(
      questionDataSource,
      QuestionMapper(),
    );
    quizRepository = QuizRepositoryImpl(
      quizDataSource,
      questionDataSource,
      QuizMapper(),
      QuestionMapper(),
    );

    await seedTestQuestions();
  });

  tearDown(() => db.close());

  group('Quiz Flow Integration', () {
    test('creates custom quiz with specified questions', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3, 4, 5],
      );

      expect(quiz.totalQuestions, 5);
      expect(quiz.status, QuizStatus.inProgress);
      expect(quiz.type, QuizType.custom);
    });

    test('submits answer and updates state', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3],
      );

      // Submit correct answer
      await quizRepository.submitAnswer(
        quizId: quiz.id,
        questionId: 1,
        selectedAnswerId: 'a1',
        wasCorrect: true,
      );

      // Get updated quiz
      final updatedQuiz = await quizRepository.getQuizById(quiz.id);

      expect(updatedQuiz, isNotNull);
      expect(updatedQuiz!.answeredCount, 1);

      // Check the question answer was recorded
      final answeredQuestion =
          updatedQuiz.questions.firstWhere((q) => q.questionId == 1);
      expect(answeredQuestion.selectedAnswerId, 'a1');
      expect(answeredQuestion.wasCorrect, true);
    });

    test('completes quiz and calculates result', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3, 4, 5],
      );

      // Answer all questions (4 correct, 1 wrong = 80%)
      for (int i = 0; i < 5; i++) {
        final questionId = quiz.questions[i].questionId;
        final isCorrect = i < 4; // First 4 correct
        await quizRepository.submitAnswer(
          quizId: quiz.id,
          questionId: questionId,
          selectedAnswerId: isCorrect ? 'a1' : 'a2',
          wasCorrect: isCorrect,
        );
      }

      // Complete quiz
      final result = await quizRepository.completeQuiz(quiz.id);

      expect(result.totalQuestions, 5);
      expect(result.correctAnswers, 4);
      expect(result.quizType, QuizType.custom);
      expect(result.passed, true); // 80% >= 70% threshold
    });

    test('custom quiz fails with less than 70%', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      );

      // Answer 6 correct, 4 wrong = 60%
      for (int i = 0; i < 10; i++) {
        final questionId = quiz.questions[i].questionId;
        final isCorrect = i < 6;
        await quizRepository.submitAnswer(
          quizId: quiz.id,
          questionId: questionId,
          selectedAnswerId: isCorrect ? 'a1' : 'a2',
          wasCorrect: isCorrect,
        );
      }

      final result = await quizRepository.completeQuiz(quiz.id);

      expect(result.correctAnswers, 6);
      expect(result.passed, false); // 60% < 70%
    });

    test('updates question ranking after answer', () async {
      // Get initial ranking
      var rankings = await questionRepository.getRankingsForQuestions([1, 2]);
      expect(rankings[1], 0);
      expect(rankings[2], 0);

      // Answer question 1 correctly
      await questionRepository.updateRanking(questionId: 1, wasCorrect: true);

      // Answer question 2 incorrectly
      await questionRepository.updateRanking(questionId: 2, wasCorrect: false);

      // Check updated rankings
      rankings = await questionRepository.getRankingsForQuestions([1, 2]);
      expect(rankings[1], 1); // Incremented
      expect(rankings[2], 0); // Reset to 0
    });

    test('resumes quiz at saved position', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3, 4, 5],
      );

      // Answer first 2 questions
      for (int i = 0; i < 2; i++) {
        await quizRepository.submitAnswer(
          quizId: quiz.id,
          questionId: quiz.questions[i].questionId,
          selectedAnswerId: 'a1',
          wasCorrect: true,
        );
      }

      // Update current index
      await quizRepository.updateCurrentIndex(quiz.id, 2);

      // Resume quiz
      final resumedQuiz = await quizRepository.getQuizById(quiz.id);

      expect(resumedQuiz, isNotNull);
      expect(resumedQuiz!.currentQuestionIndex, 2);
      expect(resumedQuiz.answeredCount, 2);
      expect(resumedQuiz.canResume, true);
    });

    test('abandons quiz marks status correctly', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1, 2, 3],
      );

      await quizRepository.abandonQuiz(quiz.id);

      final abandonedQuiz = await quizRepository.getQuizById(quiz.id);

      expect(abandonedQuiz, isNotNull);
      expect(abandonedQuiz!.status, QuizStatus.abandoned);
      expect(abandonedQuiz.canResume, false);
    });

    test('gets resumable quizzes', () async {
      // Create 3 quizzes with different statuses
      final quiz1 = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1],
      );
      final quiz2 = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [2],
      );
      final quiz3 = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [3],
      );

      // Complete quiz2
      await quizRepository.submitAnswer(
        quizId: quiz2.id,
        questionId: 2,
        selectedAnswerId: 'a1',
        wasCorrect: true,
      );
      await quizRepository.completeQuiz(quiz2.id);

      // Abandon quiz3
      await quizRepository.abandonQuiz(quiz3.id);

      // Get resumable quizzes
      final resumable = await quizRepository.getResumableQuizzes();

      expect(resumable.length, 1);
      expect(resumable.first.id, quiz1.id);
    });

    test('deletes quiz and removes from history', () async {
      final quiz = await quizRepository.createQuiz(
        type: QuizType.custom,
        customQuestionIds: [1],
      );

      // Verify exists
      var history = await quizRepository.getQuizHistory();
      expect(history.length, 1);

      // Delete
      await quizRepository.deleteQuiz(quiz.id);

      // Verify removed
      history = await quizRepository.getQuizHistory();
      expect(history, isEmpty);
    });
  });
}
