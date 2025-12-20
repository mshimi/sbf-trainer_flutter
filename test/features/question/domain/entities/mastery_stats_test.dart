import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/question_fixtures.dart';

void main() {
  group('MasteryStats', () {
    group('progressPercentage', () {
      test('calculates correctly', () {
        final stats = createMasteryStats(
          totalQuestions: 300,
          masteredQuestions: 150,
        );

        expect(stats.progressPercentage, 0.5);
      });

      test('returns 0 when totalQuestions is 0 (no division by zero)', () {
        final stats = createMasteryStats(
          totalQuestions: 0,
          masteredQuestions: 0,
        );

        expect(stats.progressPercentage, 0.0);
      });

      test('returns 1.0 when all questions mastered', () {
        final stats = createMasteryStats(
          totalQuestions: 300,
          masteredQuestions: 300,
        );

        expect(stats.progressPercentage, 1.0);
      });

      test('returns 0.0 when no questions mastered', () {
        final stats = createMasteryStats(
          totalQuestions: 300,
          masteredQuestions: 0,
        );

        expect(stats.progressPercentage, 0.0);
      });

      test('calculates fractional progress correctly', () {
        final stats = createMasteryStats(
          totalQuestions: 100,
          masteredQuestions: 33,
        );

        expect(stats.progressPercentage, 0.33);
      });
    });
  });
}
