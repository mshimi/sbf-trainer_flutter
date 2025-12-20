import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/question/domain/entities/mastery_stats.dart';
import 'package:sbf_trainer/features/question/domain/usecases/get_mastery_stats.dart';

import '../../../../mocks/mock_repositories.dart';

void main() {
  late GetMasteryStats useCase;
  late MockQuestionRepository mockQuestionRepository;
  late MockQuestionSettingsRepository mockSettingsRepository;

  setUp(() {
    mockQuestionRepository = MockQuestionRepository();
    mockSettingsRepository = MockQuestionSettingsRepository();
    useCase = GetMasteryStats(mockQuestionRepository, mockSettingsRepository);
  });

  group('GetMasteryStats', () {
    group('call()', () {
      test('fetches threshold then calculates stats', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.getQuestionCount())
            .thenAnswer((_) async => 300);
        when(() => mockQuestionRepository.getMasteredQuestionCount(3))
            .thenAnswer((_) async => 150);

        final result = await useCase();

        expect(result.totalQuestions, 300);
        expect(result.masteredQuestions, 150);
        expect(result.progressPercentage, 0.5);
      });

      test('applies correct threshold from settings', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 5);
        when(() => mockQuestionRepository.getQuestionCount())
            .thenAnswer((_) async => 300);
        when(() => mockQuestionRepository.getMasteredQuestionCount(5))
            .thenAnswer((_) async => 100);

        await useCase();

        verify(() => mockQuestionRepository.getMasteredQuestionCount(5)).called(1);
      });

      test('handles zero questions', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.getQuestionCount())
            .thenAnswer((_) async => 0);
        when(() => mockQuestionRepository.getMasteredQuestionCount(3))
            .thenAnswer((_) async => 0);

        final result = await useCase();

        expect(result.totalQuestions, 0);
        expect(result.masteredQuestions, 0);
        expect(result.progressPercentage, 0.0);
      });

      test('handles no mastered questions', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.getQuestionCount())
            .thenAnswer((_) async => 300);
        when(() => mockQuestionRepository.getMasteredQuestionCount(3))
            .thenAnswer((_) async => 0);

        final result = await useCase();

        expect(result.totalQuestions, 300);
        expect(result.masteredQuestions, 0);
        expect(result.progressPercentage, 0.0);
      });

      test('propagates settings repository exceptions', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenThrow(Exception('Settings error'));

        expect(() => useCase(), throwsA(isA<Exception>()));
      });

      test('propagates question repository exceptions', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.getQuestionCount())
            .thenThrow(Exception('Database error'));

        expect(() => useCase(), throwsA(isA<Exception>()));
      });
    });

    group('watch()', () {
      test('combines streams correctly', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.watchQuestionCount())
            .thenAnswer((_) => Stream.value(300));
        when(() => mockQuestionRepository.watchMasteredQuestionCount(3))
            .thenAnswer((_) => Stream.value(150));

        final stream = useCase.watch();
        final result = await stream.first;

        expect(result, isA<MasteryStats>());
        expect(result.totalQuestions, 300);
        expect(result.masteredQuestions, 150);
      });

      test('emits updates when total count changes', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.watchQuestionCount())
            .thenAnswer((_) => Stream.fromIterable([300, 310]));
        when(() => mockQuestionRepository.watchMasteredQuestionCount(3))
            .thenAnswer((_) => Stream.value(150));

        final stream = useCase.watch();
        final results = await stream.take(2).toList();

        expect(results.length, 2);
        expect(results[0].totalQuestions, 300);
        expect(results[1].totalQuestions, 310);
      });

      test('emits updates when mastered count changes', () async {
        when(() => mockSettingsRepository.getMasteryThreshold())
            .thenAnswer((_) async => 3);
        when(() => mockQuestionRepository.watchQuestionCount())
            .thenAnswer((_) => Stream.value(300));
        when(() => mockQuestionRepository.watchMasteredQuestionCount(3))
            .thenAnswer((_) => Stream.fromIterable([150, 160]));

        final stream = useCase.watch();
        final results = await stream.take(2).toList();

        expect(results.length, 2);
        expect(results[0].masteredQuestions, 150);
        expect(results[1].masteredQuestions, 160);
      });
    });
  });
}
