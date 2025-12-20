import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/features/quiz/data/mappers/quiz_mapper.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';

import '../../../../fixtures/db_fixtures.dart';
import '../../../../fixtures/quiz_fixtures.dart';

void main() {
  late QuizMapper mapper;

  setUp(() {
    mapper = QuizMapper();
  });

  group('QuizMapper', () {
    group('fromDbRows', () {
      test('correctly maps quiz row and questions', () {
        final quizRow = createQuizzeRow(
          id: 'quiz-1',
          quizType: 'motor',
          examSheetIndex: 5,
          status: 'in_progress',
          currentQuestionIndex: 2,
        );
        final questionRows = createQuizQuestionRows(count: 3);

        final quiz = mapper.fromDbRows(quizRow, questionRows);

        expect(quiz.id, 'quiz-1');
        expect(quiz.type, QuizType.motor);
        expect(quiz.examSheetIndex, 5);
        expect(quiz.status, QuizStatus.inProgress);
        expect(quiz.currentQuestionIndex, 2);
        expect(quiz.questions.length, 3);
      });

      test('sorts questions by orderIndex', () {
        final quizRow = createQuizzeRow();
        final questionRows = [
          createQuizQuestionRow(questionId: 1, orderIndex: 2),
          createQuizQuestionRow(questionId: 2, orderIndex: 0),
          createQuizQuestionRow(questionId: 3, orderIndex: 1),
        ];

        final quiz = mapper.fromDbRows(quizRow, questionRows);

        expect(quiz.questions[0].questionId, 2); // orderIndex 0
        expect(quiz.questions[1].questionId, 3); // orderIndex 1
        expect(quiz.questions[2].questionId, 1); // orderIndex 2
      });

      test('parses shuffledAnswerIds from JSON', () {
        final quizRow = createQuizzeRow();
        final questionRows = [
          createQuizQuestionRow(
            shuffledAnswerIds: ['a4', 'a1', 'a3', 'a2'],
          ),
        ];

        final quiz = mapper.fromDbRows(quizRow, questionRows);

        expect(quiz.questions[0].shuffledAnswerIds, ['a4', 'a1', 'a3', 'a2']);
      });
    });

    group('quizTypeToString', () {
      test('converts motor to "motor"', () {
        expect(mapper.quizTypeToString(QuizType.motor), 'motor');
      });

      test('converts sailingOnly to "sailing_only"', () {
        expect(mapper.quizTypeToString(QuizType.sailingOnly), 'sailing_only');
      });

      test('converts combined to "combined"', () {
        expect(mapper.quizTypeToString(QuizType.combined), 'combined');
      });

      test('converts custom to "custom"', () {
        expect(mapper.quizTypeToString(QuizType.custom), 'custom');
      });
    });

    group('_parseQuizType', () {
      test('parses all quiz types correctly', () {
        final quizTypes = {
          'motor': QuizType.motor,
          'sailing_only': QuizType.sailingOnly,
          'combined': QuizType.combined,
          'custom': QuizType.custom,
        };

        for (final entry in quizTypes.entries) {
          final quizRow = createQuizzeRow(quizType: entry.key);
          final quiz = mapper.fromDbRows(quizRow, []);
          expect(quiz.type, entry.value,
              reason: 'Failed for type: ${entry.key}');
        }
      });

      test('defaults to custom for unknown type', () {
        final quizRow = createQuizzeRow(quizType: 'unknown');
        final quiz = mapper.fromDbRows(quizRow, []);
        expect(quiz.type, QuizType.custom);
      });
    });

    group('quizStatusToString', () {
      test('converts inProgress to "in_progress"', () {
        expect(mapper.quizStatusToString(QuizStatus.inProgress), 'in_progress');
      });

      test('converts completed to "completed"', () {
        expect(mapper.quizStatusToString(QuizStatus.completed), 'completed');
      });

      test('converts abandoned to "abandoned"', () {
        expect(mapper.quizStatusToString(QuizStatus.abandoned), 'abandoned');
      });
    });

    group('_parseQuizStatus', () {
      test('parses all status values correctly', () {
        final statuses = {
          'in_progress': QuizStatus.inProgress,
          'completed': QuizStatus.completed,
          'abandoned': QuizStatus.abandoned,
        };

        for (final entry in statuses.entries) {
          final quizRow = createQuizzeRow(status: entry.key);
          final quiz = mapper.fromDbRows(quizRow, []);
          expect(quiz.status, entry.value,
              reason: 'Failed for status: ${entry.key}');
        }
      });

      test('defaults to inProgress for unknown status', () {
        final quizRow = createQuizzeRow(status: 'unknown');
        final quiz = mapper.fromDbRows(quizRow, []);
        expect(quiz.status, QuizStatus.inProgress);
      });
    });

    group('createResult', () {
      test('calculates duration correctly', () {
        final startedAt = DateTime(2024, 1, 1, 10, 0);
        final endedAt = DateTime(2024, 1, 1, 10, 15);
        final quiz = createQuiz(
          startedAt: startedAt,
          endedAt: endedAt,
          questions: createQuizQuestionsList(
            count: 30,
            answeredCount: 30,
            correctCount: 27,
          ),
        );

        final result = mapper.createResult(quiz);

        expect(result.duration, const Duration(minutes: 15));
      });

      test('returns zero duration when endedAt is null', () {
        final quiz = createQuiz(
          endedAt: null,
          questions: createQuizQuestionsList(count: 10, answeredCount: 10),
        );

        final result = mapper.createResult(quiz);

        expect(result.duration, Duration.zero);
      });

      test('calculates passed correctly (90% threshold)', () {
        // 27/30 points = 90% = passed
        final passingQuiz = createQuiz(
          questions: createQuizQuestionsList(
            count: 30,
            answeredCount: 30,
            correctCount: 27,
          ),
        );

        final passResult = mapper.createResult(passingQuiz);
        expect(passResult.passed, true);

        // 26/30 points = 86.7% = failed
        final failingQuiz = createQuiz(
          questions: createQuizQuestionsList(
            count: 30,
            answeredCount: 30,
            correctCount: 26,
          ),
        );

        final failResult = mapper.createResult(failingQuiz);
        expect(failResult.passed, false);
      });

      test('includes quiz statistics', () {
        final quiz = createQuiz(
          type: QuizType.motor,
          questions: createQuizQuestionsList(
            count: 30,
            answeredCount: 30,
            correctCount: 25,
          ),
        );

        final result = mapper.createResult(quiz);

        expect(result.quizType, QuizType.motor);
        expect(result.totalQuestions, 30);
        expect(result.correctAnswers, 25);
        expect(result.totalPoints, 30);
        expect(result.earnedPoints, 25);
      });
    });
  });
}
