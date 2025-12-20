import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/submit_answer.dart';

import '../../../../mocks/mock_repositories.dart';

void main() {
  late SubmitAnswer useCase;
  late MockQuizRepository mockRepository;

  setUp(() {
    mockRepository = MockQuizRepository();
    useCase = SubmitAnswer(mockRepository);
  });

  group('SubmitAnswer', () {
    test('delegates to repository.submitAnswer with correct params', () async {
      when(() => mockRepository.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            selectedAnswerId: any(named: 'selectedAnswerId'),
            wasCorrect: any(named: 'wasCorrect'),
          )).thenAnswer((_) async {});

      await useCase(
        quizId: 'quiz-1',
        questionId: 1,
        selectedAnswerId: 'a1',
        wasCorrect: true,
      );

      verify(() => mockRepository.submitAnswer(
            quizId: 'quiz-1',
            questionId: 1,
            selectedAnswerId: 'a1',
            wasCorrect: true,
          )).called(1);
    });

    test('delegates correct answer submission', () async {
      when(() => mockRepository.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            selectedAnswerId: any(named: 'selectedAnswerId'),
            wasCorrect: any(named: 'wasCorrect'),
          )).thenAnswer((_) async {});

      await useCase(
        quizId: 'quiz-1',
        questionId: 5,
        selectedAnswerId: 'a3',
        wasCorrect: true,
      );

      verify(() => mockRepository.submitAnswer(
            quizId: 'quiz-1',
            questionId: 5,
            selectedAnswerId: 'a3',
            wasCorrect: true,
          )).called(1);
    });

    test('delegates incorrect answer submission', () async {
      when(() => mockRepository.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            selectedAnswerId: any(named: 'selectedAnswerId'),
            wasCorrect: any(named: 'wasCorrect'),
          )).thenAnswer((_) async {});

      await useCase(
        quizId: 'quiz-1',
        questionId: 5,
        selectedAnswerId: 'a2',
        wasCorrect: false,
      );

      verify(() => mockRepository.submitAnswer(
            quizId: 'quiz-1',
            questionId: 5,
            selectedAnswerId: 'a2',
            wasCorrect: false,
          )).called(1);
    });

    test('propagates repository exceptions', () async {
      when(() => mockRepository.submitAnswer(
            quizId: any(named: 'quizId'),
            questionId: any(named: 'questionId'),
            selectedAnswerId: any(named: 'selectedAnswerId'),
            wasCorrect: any(named: 'wasCorrect'),
          )).thenThrow(Exception('Database error'));

      expect(
        () => useCase(
          quizId: 'quiz-1',
          questionId: 1,
          selectedAnswerId: 'a1',
          wasCorrect: true,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
