import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/start_quiz.dart';

import '../../../../fixtures/quiz_fixtures.dart';
import '../../../../mocks/mock_repositories.dart';

void main() {
  late StartQuiz useCase;
  late MockQuizRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(QuizType.motor);
  });

  setUp(() {
    mockRepository = MockQuizRepository();
    useCase = StartQuiz(mockRepository);
  });

  group('StartQuiz', () {
    test('delegates to repository.createQuiz with motor type', () async {
      final expectedQuiz = createQuiz(type: QuizType.motor);
      when(() => mockRepository.createQuiz(
            type: any(named: 'type'),
            examSheetIndex: any(named: 'examSheetIndex'),
            customQuestionIds: any(named: 'customQuestionIds'),
          )).thenAnswer((_) async => expectedQuiz);

      final result = await useCase(type: QuizType.motor);

      expect(result, equals(expectedQuiz));
      verify(() => mockRepository.createQuiz(
            type: QuizType.motor,
            examSheetIndex: null,
            customQuestionIds: null,
          )).called(1);
    });

    test('delegates to repository.createQuiz with sailing type', () async {
      final expectedQuiz = createQuiz(type: QuizType.sailingOnly);
      when(() => mockRepository.createQuiz(
            type: any(named: 'type'),
            examSheetIndex: any(named: 'examSheetIndex'),
            customQuestionIds: any(named: 'customQuestionIds'),
          )).thenAnswer((_) async => expectedQuiz);

      final result = await useCase(type: QuizType.sailingOnly);

      expect(result.type, QuizType.sailingOnly);
      verify(() => mockRepository.createQuiz(
            type: QuizType.sailingOnly,
            examSheetIndex: null,
            customQuestionIds: null,
          )).called(1);
    });

    test('delegates with examSheetIndex when provided', () async {
      final expectedQuiz = createQuiz(examSheetIndex: 5);
      when(() => mockRepository.createQuiz(
            type: any(named: 'type'),
            examSheetIndex: any(named: 'examSheetIndex'),
            customQuestionIds: any(named: 'customQuestionIds'),
          )).thenAnswer((_) async => expectedQuiz);

      await useCase(type: QuizType.motor, examSheetIndex: 5);

      verify(() => mockRepository.createQuiz(
            type: QuizType.motor,
            examSheetIndex: 5,
            customQuestionIds: null,
          )).called(1);
    });

    test('delegates with customQuestionIds for custom quiz', () async {
      final customIds = [1, 2, 3, 4, 5];
      final expectedQuiz = createQuiz(type: QuizType.custom);
      when(() => mockRepository.createQuiz(
            type: any(named: 'type'),
            examSheetIndex: any(named: 'examSheetIndex'),
            customQuestionIds: any(named: 'customQuestionIds'),
          )).thenAnswer((_) async => expectedQuiz);

      await useCase(type: QuizType.custom, customQuestionIds: customIds);

      verify(() => mockRepository.createQuiz(
            type: QuizType.custom,
            examSheetIndex: null,
            customQuestionIds: customIds,
          )).called(1);
    });

    test('propagates repository exceptions', () async {
      when(() => mockRepository.createQuiz(
            type: any(named: 'type'),
            examSheetIndex: any(named: 'examSheetIndex'),
            customQuestionIds: any(named: 'customQuestionIds'),
          )).thenThrow(Exception('Database error'));

      expect(
        () => useCase(type: QuizType.motor),
        throwsA(isA<Exception>()),
      );
    });
  });
}
