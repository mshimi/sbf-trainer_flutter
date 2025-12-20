import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';

import '../../../../fixtures/quiz_fixtures.dart';

void main() {
  group('Quiz', () {
    group('totalQuestions', () {
      test('returns correct count of questions', () {
        final quiz = createQuiz(
          questions: createQuizQuestionsList(count: 5),
        );

        expect(quiz.totalQuestions, 5);
      });

      test('returns 0 for empty quiz', () {
        final quiz = createQuiz(questions: []);

        expect(quiz.totalQuestions, 0);
      });
    });

    group('answeredCount', () {
      test('counts only answered questions', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 3,
        );

        expect(quiz.answeredCount, 3);
      });

      test('returns 0 when no questions answered', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 0,
        );

        expect(quiz.answeredCount, 0);
      });

      test('counts all when all answered', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 10,
        );

        expect(quiz.answeredCount, 10);
      });
    });

    group('correctCount', () {
      test('counts only correct answers', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 5,
          correctCount: 3,
        );

        expect(quiz.correctCount, 3);
      });

      test('returns 0 when no correct answers', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 5,
          correctCount: 0,
        );

        expect(quiz.correctCount, 0);
      });
    });

    group('totalPoints', () {
      test('sums all question points', () {
        final questions = [
          createQuizQuestionAnswer(questionId: 1, points: 1),
          createQuizQuestionAnswer(questionId: 2, points: 2),
          createQuizQuestionAnswer(questionId: 3, points: 3),
        ];
        final quiz = createQuiz(questions: questions);

        expect(quiz.totalPoints, 6);
      });

      test('returns 0 for empty quiz', () {
        final quiz = createQuiz(questions: []);

        expect(quiz.totalPoints, 0);
      });
    });

    group('earnedPoints', () {
      test('sums only correct answer points', () {
        final questions = [
          createQuizQuestionAnswer(
            questionId: 1,
            points: 1,
            selectedAnswerId: 'a1',
            wasCorrect: true,
          ),
          createQuizQuestionAnswer(
            questionId: 2,
            points: 2,
            selectedAnswerId: 'a2',
            wasCorrect: false,
          ),
          createQuizQuestionAnswer(
            questionId: 3,
            points: 3,
            selectedAnswerId: 'a1',
            wasCorrect: true,
          ),
        ];
        final quiz = createQuiz(questions: questions);

        expect(quiz.earnedPoints, 4); // 1 + 3
      });

      test('returns 0 when no correct answers', () {
        final questions = [
          createQuizQuestionAnswer(
            questionId: 1,
            points: 1,
            selectedAnswerId: 'a2',
            wasCorrect: false,
          ),
        ];
        final quiz = createQuiz(questions: questions);

        expect(quiz.earnedPoints, 0);
      });
    });

    group('progressPercentage', () {
      test('calculates correctly', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 3,
        );

        expect(quiz.progressPercentage, 0.3);
      });

      test('returns 0 for empty quiz (no division by zero)', () {
        final quiz = createQuiz(questions: []);

        expect(quiz.progressPercentage, 0);
      });

      test('returns 1.0 when all answered', () {
        final quiz = createQuizWithAnswers(
          totalQuestions: 10,
          answeredCount: 10,
        );

        expect(quiz.progressPercentage, 1.0);
      });
    });

    group('isComplete', () {
      test('returns true when status is completed', () {
        final quiz = createQuiz(status: QuizStatus.completed);

        expect(quiz.isComplete, true);
      });

      test('returns false when status is inProgress', () {
        final quiz = createQuiz(status: QuizStatus.inProgress);

        expect(quiz.isComplete, false);
      });

      test('returns false when status is abandoned', () {
        final quiz = createQuiz(status: QuizStatus.abandoned);

        expect(quiz.isComplete, false);
      });
    });

    group('canResume', () {
      test('returns true when status is inProgress', () {
        final quiz = createQuiz(status: QuizStatus.inProgress);

        expect(quiz.canResume, true);
      });

      test('returns false when status is completed', () {
        final quiz = createQuiz(status: QuizStatus.completed);

        expect(quiz.canResume, false);
      });

      test('returns false when status is abandoned', () {
        final quiz = createQuiz(status: QuizStatus.abandoned);

        expect(quiz.canResume, false);
      });
    });

    group('copyWith', () {
      test('creates copy with updated status', () {
        final original = createQuiz(status: QuizStatus.inProgress);
        final copy = original.copyWith(status: QuizStatus.completed);

        expect(copy.status, QuizStatus.completed);
        expect(copy.id, original.id);
        expect(copy.type, original.type);
      });

      test('creates copy with updated currentQuestionIndex', () {
        final original = createQuiz(currentQuestionIndex: 0);
        final copy = original.copyWith(currentQuestionIndex: 5);

        expect(copy.currentQuestionIndex, 5);
      });
    });
  });
}
