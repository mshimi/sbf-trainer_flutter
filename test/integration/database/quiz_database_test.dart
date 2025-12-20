import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/core/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  group('Quiz Database Integration', () {
    group('Quiz CRUD operations', () {
      test('creates and retrieves quiz', () async {
        // Insert a quiz
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 30,
            ));

        // Retrieve the quiz
        final quizzes = await db.select(db.quizzes).get();

        expect(quizzes.length, 1);
        expect(quizzes.first.id, 'quiz-1');
        expect(quizzes.first.quizType, 'motor');
        expect(quizzes.first.totalQuestions, 30);
        expect(quizzes.first.status, 'in_progress');
      });

      test('updates quiz status to completed', () async {
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 30,
            ));

        // Update status
        await (db.update(db.quizzes)..where((t) => t.id.equals('quiz-1')))
            .write(const QuizzesCompanion(status: Value('completed')));

        final quiz = await (db.select(db.quizzes)
              ..where((t) => t.id.equals('quiz-1')))
            .getSingle();

        expect(quiz.status, 'completed');
      });

      test('deletes quiz and associated questions', () async {
        // Insert quiz
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 1,
            ));

        // Insert quiz question
        await db.into(db.quizQuestions).insert(QuizQuestionsCompanion.insert(
              quizId: 'quiz-1',
              questionId: 1,
              orderIndex: 0,
              shuffledAnswerIdsJson: '["a1","a2","a3","a4"]',
              points: 1,
            ));

        // Delete quiz questions first (foreign key constraint)
        await (db.delete(db.quizQuestions)
              ..where((t) => t.quizId.equals('quiz-1')))
            .go();
        // Delete quiz
        await (db.delete(db.quizzes)..where((t) => t.id.equals('quiz-1'))).go();

        final quizzes = await db.select(db.quizzes).get();
        final questions = await db.select(db.quizQuestions).get();

        expect(quizzes, isEmpty);
        expect(questions, isEmpty);
      });
    });

    group('Quiz Questions operations', () {
      test('inserts and retrieves quiz questions', () async {
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 2,
            ));

        await db.into(db.quizQuestions).insert(QuizQuestionsCompanion.insert(
              quizId: 'quiz-1',
              questionId: 1,
              orderIndex: 0,
              shuffledAnswerIdsJson: jsonEncode(['a1', 'a2', 'a3', 'a4']),
              points: 1,
            ));
        await db.into(db.quizQuestions).insert(QuizQuestionsCompanion.insert(
              quizId: 'quiz-1',
              questionId: 2,
              orderIndex: 1,
              shuffledAnswerIdsJson: jsonEncode(['a3', 'a1', 'a4', 'a2']),
              points: 1,
            ));

        final questions = await (db.select(db.quizQuestions)
              ..where((t) => t.quizId.equals('quiz-1'))
              ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
            .get();

        expect(questions.length, 2);
        expect(questions[0].questionId, 1);
        expect(questions[1].questionId, 2);
      });

      test('updates quiz question with answer', () async {
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 1,
            ));

        await db.into(db.quizQuestions).insert(QuizQuestionsCompanion.insert(
              quizId: 'quiz-1',
              questionId: 1,
              orderIndex: 0,
              shuffledAnswerIdsJson: '["a1","a2","a3","a4"]',
              points: 1,
            ));

        // Submit answer
        final now = DateTime.now();
        await (db.update(db.quizQuestions)
              ..where((t) => t.quizId.equals('quiz-1'))
              ..where((t) => t.questionId.equals(1)))
            .write(QuizQuestionsCompanion(
          selectedAnswerId: const Value('a1'),
          wasCorrect: const Value(true),
          answeredAt: Value(now),
        ));

        final question = await (db.select(db.quizQuestions)
              ..where((t) => t.quizId.equals('quiz-1'))
              ..where((t) => t.questionId.equals(1)))
            .getSingle();

        expect(question.selectedAnswerId, 'a1');
        expect(question.wasCorrect, true);
        expect(question.answeredAt, isNotNull);
      });
    });

    group('Question Rankings', () {
      test('inserts and updates question ranking', () async {
        // First need to insert a question
        await db.into(db.questions).insert(QuestionsCompanion.insert(
              id: const Value(1),
              categoryId: 'basisfragen',
              questionText: 'Test question?',
              points: 1,
            ));

        // Insert ranking
        await db.into(db.questionRankings).insert(
              QuestionRankingsCompanion.insert(
                questionId: const Value(1),
                timesCorrect: const Value(0),
              ),
            );

        // Get initial ranking
        var ranking = await (db.select(db.questionRankings)
              ..where((t) => t.questionId.equals(1)))
            .getSingle();
        expect(ranking.timesCorrect, 0);

        // Increment on correct answer
        await (db.update(db.questionRankings)
              ..where((t) => t.questionId.equals(1)))
            .write(const QuestionRankingsCompanion(
          timesCorrect: Value(1),
        ));

        ranking = await (db.select(db.questionRankings)
              ..where((t) => t.questionId.equals(1)))
            .getSingle();
        expect(ranking.timesCorrect, 1);
      });

      test('counts mastered questions', () async {
        // Insert questions and rankings
        for (int i = 1; i <= 5; i++) {
          await db.into(db.questions).insert(QuestionsCompanion.insert(
                id: Value(i),
                categoryId: 'basisfragen',
                questionText: 'Question $i?',
                points: 1,
              ));
          await db.into(db.questionRankings).insert(
                QuestionRankingsCompanion.insert(
                  questionId: Value(i),
                  timesCorrect: Value(i), // 1, 2, 3, 4, 5
                ),
              );
        }

        // Count mastered (timesCorrect >= 3) - fetch all and filter in Dart
        const threshold = 3;
        final allRankings = await db.select(db.questionRankings).get();
        final masteredCount =
            allRankings.where((r) => r.timesCorrect >= threshold).length;

        expect(masteredCount, 3); // Questions with timesCorrect 3, 4, 5
      });
    });

    group('Watch streams', () {
      test('watchOpenQuizzes emits on new quiz', () async {
        final stream = (db.select(db.quizzes)
              ..where((t) => t.status.equals('in_progress')))
            .watch();

        final expectedStates = [
          [], // Initial empty
          isA<List<Quizze>>()
              .having((l) => l.length, 'length', 1), // After insert
        ];

        expectLater(stream, emitsInOrder(expectedStates));

        // Give time for initial empty emission
        await Future.delayed(const Duration(milliseconds: 50));

        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 30,
            ));
      });
    });

    group('Clear and reset', () {
      test('clearAllData removes all data', () async {
        // Insert data
        await db.into(db.questions).insert(QuestionsCompanion.insert(
              id: const Value(1),
              categoryId: 'test',
              questionText: 'Test?',
              points: 1,
            ));
        await db.into(db.quizzes).insert(QuizzesCompanion.insert(
              id: 'quiz-1',
              quizType: 'motor',
              startedAt: DateTime.now(),
              totalQuestions: 1,
            ));

        await db.clearAllData();

        final questions = await db.select(db.questions).get();
        final quizzes = await db.select(db.quizzes).get();

        expect(questions, isEmpty);
        expect(quizzes, isEmpty);
      });
    });
  });
}
