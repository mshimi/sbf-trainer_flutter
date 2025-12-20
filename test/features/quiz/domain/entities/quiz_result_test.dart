import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz_result.dart';

import '../../../../fixtures/quiz_fixtures.dart';

void main() {
  group('QuizResult', () {
    group('percentage', () {
      test('calculates earned/total points correctly', () {
        final result = createQuizResult(
          earnedPoints: 25,
          totalPoints: 30,
        );

        expect(result.percentage, closeTo(83.33, 0.01));
      });

      test('returns 0 when totalPoints is 0', () {
        final result = createQuizResult(
          earnedPoints: 0,
          totalPoints: 0,
        );

        expect(result.percentage, 0);
      });

      test('returns 100 when all points earned', () {
        final result = createQuizResult(
          earnedPoints: 30,
          totalPoints: 30,
        );

        expect(result.percentage, 100);
      });
    });

    group('accuracy', () {
      test('calculates correct/total questions correctly', () {
        final result = createQuizResult(
          correctAnswers: 25,
          totalQuestions: 30,
        );

        expect(result.accuracy, closeTo(83.33, 0.01));
      });

      test('returns 0 when totalQuestions is 0', () {
        final result = createQuizResult(
          correctAnswers: 0,
          totalQuestions: 0,
        );

        expect(result.accuracy, 0);
      });

      test('returns 100 when all answers correct', () {
        final result = createQuizResult(
          correctAnswers: 30,
          totalQuestions: 30,
        );

        expect(result.accuracy, 100);
      });
    });

    group('failedCategories', () {
      test('returns only failed categories', () {
        final categoryResults = [
          createCategoryResult(categoryId: 'basis', passed: true),
          createCategoryResult(categoryId: 'specific', passed: false),
          createCategoryResult(categoryId: 'sailing', passed: true),
        ];
        final result = createQuizResult(categoryResults: categoryResults);

        expect(result.failedCategories.length, 1);
        expect(result.failedCategories.first.categoryId, 'specific');
      });

      test('returns empty list when all categories passed', () {
        final categoryResults = [
          createCategoryResult(passed: true),
          createCategoryResult(categoryId: 'specific', passed: true),
        ];
        final result = createQuizResult(categoryResults: categoryResults);

        expect(result.failedCategories, isEmpty);
      });

      test('returns all categories when all failed', () {
        final categoryResults = [
          createCategoryResult(categoryId: 'basis', passed: false),
          createCategoryResult(categoryId: 'specific', passed: false),
        ];
        final result = createQuizResult(categoryResults: categoryResults);

        expect(result.failedCategories.length, 2);
      });
    });
  });

  group('CategoryResult', () {
    group('errors', () {
      test('calculates total - correct', () {
        final category = createCategoryResult(
          totalQuestions: 7,
          correctAnswers: 5,
        );

        expect(category.errors, 2);
      });

      test('returns 0 when all correct', () {
        final category = createCategoryResult(
          totalQuestions: 7,
          correctAnswers: 7,
        );

        expect(category.errors, 0);
      });
    });

    group('maxErrors', () {
      test('calculates total - required', () {
        final category = createCategoryResult(
          totalQuestions: 7,
          requiredCorrect: 5,
        );

        expect(category.maxErrors, 2);
      });

      test('returns 0 when all required', () {
        final category = createCategoryResult(
          totalQuestions: 7,
          requiredCorrect: 7,
        );

        expect(category.maxErrors, 0);
      });
    });
  });

  group('ExamPassRules', () {
    test('motor exam constants are correct', () {
      expect(ExamPassRules.motorBasisRequired, 5);
      expect(ExamPassRules.motorBasisTotal, 7);
      expect(ExamPassRules.motorSpecificRequired, 18);
      expect(ExamPassRules.motorSpecificTotal, 23);
    });

    test('sailing exam constants are correct', () {
      expect(ExamPassRules.sailingBasisRequired, 5);
      expect(ExamPassRules.sailingBasisTotal, 7);
      expect(ExamPassRules.sailingSpecificRequired, 14);
      expect(ExamPassRules.sailingSpecificTotal, 18);
    });

    test('combined exam constants are correct', () {
      expect(ExamPassRules.combinedSailingSupplementRequired, 5);
      expect(ExamPassRules.combinedSailingSupplementTotal, 7);
    });

    test('custom pass percentage is 70%', () {
      expect(ExamPassRules.customPassPercentage, 0.7);
    });
  });
}
