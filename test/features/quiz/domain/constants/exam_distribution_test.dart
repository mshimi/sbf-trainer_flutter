import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/features/quiz/domain/constants/exam_distribution.dart';

void main() {
  group('ExamDistribution', () {
    group('getMotorExam', () {
      test('returns 30 questions for each valid index (0-14)', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getMotorExam(i);
          expect(exam.length, 30, reason: 'Motor exam $i should have 30 questions');
        }
      });

      test('throws RangeError for index -1', () {
        expect(
          () => ExamDistribution.getMotorExam(-1),
          throwsA(isA<RangeError>()),
        );
      });

      test('throws RangeError for index 15', () {
        expect(
          () => ExamDistribution.getMotorExam(15),
          throwsA(isA<RangeError>()),
        );
      });

      test('all question IDs are within valid range (1-253)', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getMotorExam(i);
          for (final id in exam) {
            expect(id, greaterThanOrEqualTo(1));
            expect(id, lessThanOrEqualTo(253));
          }
        }
      });
    });

    group('getSailingOnlyExam', () {
      test('returns 25 questions for each valid index (0-14)', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getSailingOnlyExam(i);
          expect(exam.length, 25, reason: 'Sailing exam $i should have 25 questions');
        }
      });

      test('throws RangeError for index -1', () {
        expect(
          () => ExamDistribution.getSailingOnlyExam(-1),
          throwsA(isA<RangeError>()),
        );
      });

      test('throws RangeError for index 15', () {
        expect(
          () => ExamDistribution.getSailingOnlyExam(15),
          throwsA(isA<RangeError>()),
        );
      });

      test('all question IDs are within valid range (1-300)', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getSailingOnlyExam(i);
          for (final id in exam) {
            expect(id, greaterThanOrEqualTo(1));
            expect(id, lessThanOrEqualTo(300));
          }
        }
      });
    });

    group('getSailingSupplement', () {
      test('returns 7 questions for each valid index (0-14)', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getSailingSupplement(i);
          expect(exam.length, 7, reason: 'Sailing supplement $i should have 7 questions');
        }
      });

      test('throws RangeError for invalid index', () {
        expect(
          () => ExamDistribution.getSailingSupplement(-1),
          throwsA(isA<RangeError>()),
        );
        expect(
          () => ExamDistribution.getSailingSupplement(15),
          throwsA(isA<RangeError>()),
        );
      });
    });

    group('getCombinedExam', () {
      test('returns 37 questions (30 motor + 7 supplement) for each valid index', () {
        for (int i = 0; i <= 14; i++) {
          final exam = ExamDistribution.getCombinedExam(i);
          expect(exam.length, 37, reason: 'Combined exam $i should have 37 questions');
        }
      });

      test('combined exam contains motor exam questions', () {
        const index = 0;
        final combined = ExamDistribution.getCombinedExam(index);
        final motor = ExamDistribution.getMotorExam(index);

        for (final motorId in motor) {
          expect(combined.contains(motorId), true,
              reason: 'Combined exam should contain motor question $motorId');
        }
      });

      test('combined exam contains sailing supplement questions', () {
        const index = 0;
        final combined = ExamDistribution.getCombinedExam(index);
        final supplement = ExamDistribution.getSailingSupplement(index);

        for (final supplementId in supplement) {
          expect(combined.contains(supplementId), true,
              reason: 'Combined exam should contain supplement question $supplementId');
        }
      });

      test('throws RangeError for invalid index', () {
        expect(
          () => ExamDistribution.getCombinedExam(-1),
          throwsA(isA<RangeError>()),
        );
        expect(
          () => ExamDistribution.getCombinedExam(15),
          throwsA(isA<RangeError>()),
        );
      });
    });

    group('constants', () {
      test('total question counts are correct', () {
        expect(ExamDistribution.totalBaseQuestions, 72);
        expect(ExamDistribution.totalMotorQuestions, 181);
        expect(ExamDistribution.totalSailingQuestions, 47);
        expect(ExamDistribution.totalQuestions, 300);
      });

      test('total questions equals sum of parts', () {
        expect(
          ExamDistribution.totalQuestions,
          ExamDistribution.totalBaseQuestions +
              ExamDistribution.totalMotorQuestions +
              ExamDistribution.totalSailingQuestions,
        );
      });
    });
  });
}
