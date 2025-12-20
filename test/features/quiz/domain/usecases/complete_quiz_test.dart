import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/complete_quiz.dart';

import '../../../../fixtures/quiz_fixtures.dart';
import '../../../../mocks/mock_repositories.dart';

void main() {
  late CompleteQuiz useCase;
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
    useCase = CompleteQuiz(mockRepository);
  });

  group('CompleteQuiz', () {
    test('delegates to repository.completeQuiz', () async {
      final expectedResult = createQuizResult(
        quizType: QuizType.motor,
        passed: true,
      );
      when(() => mockRepository.completeQuiz(any()))
          .thenAnswer((_) async => expectedResult);

      final result = await useCase('quiz-1');

      expect(result, equals(expectedResult));
      verify(() => mockRepository.completeQuiz('quiz-1')).called(1);
    });

    test('returns QuizResult from repository', () async {
      final expectedResult = createQuizResult(
        quizType: QuizType.motor,
        totalQuestions: 30,
        correctAnswers: 25,
        passed: true,
        categoryResults: createMotorExamCategoryResults(
          basisCorrect: 6,
          specificCorrect: 19,
        ),
      );
      when(() => mockRepository.completeQuiz(any()))
          .thenAnswer((_) async => expectedResult);

      final result = await useCase('quiz-1');

      expect(result.quizType, QuizType.motor);
      expect(result.totalQuestions, 30);
      expect(result.correctAnswers, 25);
      expect(result.passed, true);
      expect(result.categoryResults.length, 2);
    });

    test('returns failed result when quiz failed', () async {
      final expectedResult = createQuizResult(
        quizType: QuizType.motor,
        passed: false,
        categoryResults: createMotorExamCategoryResults(
          basisCorrect: 4, // Failed - needs 5
          specificCorrect: 18,
        ),
      );
      when(() => mockRepository.completeQuiz(any()))
          .thenAnswer((_) async => expectedResult);

      final result = await useCase('quiz-1');

      expect(result.passed, false);
      expect(result.failedCategories.length, 1);
    });

    test('propagates repository exceptions', () async {
      when(() => mockRepository.completeQuiz(any()))
          .thenThrow(Exception('Quiz not found'));

      expect(
        () => useCase('invalid-quiz-id'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
