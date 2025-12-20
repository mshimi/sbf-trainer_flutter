import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';
import 'package:sbf_trainer/features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import 'package:sbf_trainer/features/quiz/presentation/cubit/quiz_overview_state.dart';

import '../../../../fixtures/quiz_fixtures.dart';
import '../../../../mocks/mock_repositories.dart';

void main() {
  late QuizOverviewCubit cubit;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    cubit = QuizOverviewCubit(mockQuizRepository);
  });

  tearDown(() => cubit.close());

  group('QuizOverviewCubit', () {
    group('initial state', () {
      test('has initial status', () {
        expect(cubit.state.status, QuizOverviewStatus.initial);
        expect(cubit.state.openQuizzes, isEmpty);
        expect(cubit.state.completedQuizzes, isEmpty);
      });
    });

    group('startWatching', () {
      blocTest<QuizOverviewCubit, QuizOverviewState>(
        'emits loading then loaded with open quizzes',
        build: () {
          final openQuizzes = [
            createQuiz(id: 'q1', status: QuizStatus.inProgress),
          ];
          when(() => mockQuizRepository.watchOpenQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => Stream.value(openQuizzes));
          when(() => mockQuizRepository.watchCompletedQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => Stream.value([]));
          return cubit;
        },
        act: (c) => c.startWatching(),
        expect: () => [
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.loading),
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.loaded)
              .having((s) => s.openQuizzes.length, 'openQuizzes', 1),
        ],
      );

      blocTest<QuizOverviewCubit, QuizOverviewState>(
        'emits loaded with completed quizzes',
        build: () {
          final completedQuizzes = [
            createQuiz(id: 'q1', status: QuizStatus.completed),
            createQuiz(id: 'q2', status: QuizStatus.completed),
          ];
          when(() => mockQuizRepository.watchOpenQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => const Stream.empty());
          when(() => mockQuizRepository.watchCompletedQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => Stream.value(completedQuizzes));
          return cubit;
        },
        act: (c) => c.startWatching(),
        expect: () => [
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.loading),
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.loaded)
              .having((s) => s.completedQuizzes.length, 'completedQuizzes', 2),
        ],
      );

      blocTest<QuizOverviewCubit, QuizOverviewState>(
        'emits error on stream error',
        build: () {
          when(() => mockQuizRepository.watchOpenQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => Stream.error(Exception('Database error')));
          when(() => mockQuizRepository.watchCompletedQuizzes(limit: any(named: 'limit')))
              .thenAnswer((_) => const Stream.empty());
          return cubit;
        },
        act: (c) => c.startWatching(),
        expect: () => [
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.loading),
          isA<QuizOverviewState>()
              .having((s) => s.status, 'status', QuizOverviewStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );

      test('subscribes to both streams with maxDisplayItems limit', () async {
        when(() => mockQuizRepository.watchOpenQuizzes(limit: any(named: 'limit')))
            .thenAnswer((_) => Stream.value([]));
        when(() => mockQuizRepository.watchCompletedQuizzes(limit: any(named: 'limit')))
            .thenAnswer((_) => Stream.value([]));

        cubit.startWatching();

        await Future.delayed(Duration.zero);

        verify(() => mockQuizRepository.watchOpenQuizzes(
              limit: QuizOverviewCubit.maxDisplayItems,
            )).called(1);
        verify(() => mockQuizRepository.watchCompletedQuizzes(
              limit: QuizOverviewCubit.maxDisplayItems,
            )).called(1);
      });
    });

    group('hasQuizzes', () {
      test('returns true when openQuizzes is not empty', () {
        final state = QuizOverviewState(
          openQuizzes: [createQuiz()],
        );
        expect(state.hasQuizzes, true);
      });

      test('returns true when completedQuizzes is not empty', () {
        final state = QuizOverviewState(
          completedQuizzes: [createQuiz()],
        );
        expect(state.hasQuizzes, true);
      });

      test('returns false when both lists are empty', () {
        const state = QuizOverviewState();
        expect(state.hasQuizzes, false);
      });
    });

    group('close', () {
      test('cancels stream subscriptions', () async {
        final openController = StreamController<List<Quiz>>();
        final completedController = StreamController<List<Quiz>>();

        when(() => mockQuizRepository.watchOpenQuizzes(limit: any(named: 'limit')))
            .thenAnswer((_) => openController.stream);
        when(() => mockQuizRepository.watchCompletedQuizzes(limit: any(named: 'limit')))
            .thenAnswer((_) => completedController.stream);

        cubit.startWatching();
        await cubit.close();

        // Adding to a closed stream should not cause issues
        // because subscriptions should be cancelled
        expect(openController.hasListener, false);
        expect(completedController.hasListener, false);

        await openController.close();
        await completedController.close();
      });
    });
  });
}
