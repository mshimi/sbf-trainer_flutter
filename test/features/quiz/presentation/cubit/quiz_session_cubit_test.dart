import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';
import 'package:sbf_trainer/features/quiz/presentation/cubit/quiz_session_cubit.dart';
import 'package:sbf_trainer/features/quiz/presentation/cubit/quiz_session_state.dart';

import '../../../../fixtures/question_fixtures.dart';
import '../../../../fixtures/quiz_fixtures.dart';
import '../../../../mocks/mock_repositories.dart';
import '../../../../mocks/mock_usecases.dart';

void main() {
  late QuizSessionCubit cubit;
  late MockStartQuiz mockStartQuiz;
  late MockSubmitAnswer mockSubmitAnswer;
  late MockCompleteQuiz mockCompleteQuiz;
  late MockQuizRepository mockQuizRepository;
  late MockQuestionRepository mockQuestionRepository;

  setUpAll(() {
    registerFallbackValue(QuizType.motor);
  });

  setUp(() {
    mockStartQuiz = MockStartQuiz();
    mockSubmitAnswer = MockSubmitAnswer();
    mockCompleteQuiz = MockCompleteQuiz();
    mockQuizRepository = MockQuizRepository();
    mockQuestionRepository = MockQuestionRepository();

    cubit = QuizSessionCubit(
      startQuiz: mockStartQuiz,
      submitAnswer: mockSubmitAnswer,
      completeQuiz: mockCompleteQuiz,
      quizRepository: mockQuizRepository,
      questionRepository: mockQuestionRepository,
    );
  });

  tearDown(() => cubit.close());

  group('QuizSessionCubit', () {
    group('initial state', () {
      test('has initial status', () {
        expect(cubit.state.status, QuizSessionStatus.initial);
        expect(cubit.state.quiz, isNull);
        expect(cubit.state.currentQuestion, isNull);
      });
    });

    group('startNewQuiz', () {
      final testQuiz = createQuiz(
        questions: [
          createQuizQuestionAnswer(questionId: 1, orderIndex: 0),
          createQuizQuestionAnswer(questionId: 2, orderIndex: 1),
        ],
      );
      final testQuestions = [
        createQuestion(id: 1),
        createQuestion(id: 2),
      ];

      blocTest<QuizSessionCubit, QuizSessionState>(
        'emits [loading, ready] when startNewQuiz succeeds',
        build: () {
          when(() => mockStartQuiz(
                type: any(named: 'type'),
                examSheetIndex: any(named: 'examSheetIndex'),
                customQuestionIds: any(named: 'customQuestionIds'),
              )).thenAnswer((_) async => testQuiz);
          when(() => mockQuestionRepository.getQuestionsByIds(
                ids: any(named: 'ids'),
              )).thenAnswer((_) async => testQuestions);
          when(() => mockQuizRepository.updateCurrentIndex(any(), any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        act: (c) => c.startNewQuiz(type: QuizType.motor),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.loading),
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.ready)
              .having((s) => s.quiz, 'quiz', isNotNull)
              .having((s) => s.currentQuestion, 'question', isNotNull)
              .having((s) => s.currentIndex, 'currentIndex', 0),
        ],
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'emits error when startNewQuiz fails',
        build: () {
          when(() => mockStartQuiz(
                type: any(named: 'type'),
                examSheetIndex: any(named: 'examSheetIndex'),
                customQuestionIds: any(named: 'customQuestionIds'),
              )).thenThrow(Exception('Failed to start quiz'));
          return cubit;
        },
        act: (c) => c.startNewQuiz(type: QuizType.motor),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.loading),
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('selectAnswer', () {
      final testQuestion = createQuestion(
        id: 1,
        answers: [
          createAnswer(id: 'a1', text: 'Correct', isCorrect: true),
          createAnswer(id: 'a2', text: 'Wrong', isCorrect: false),
        ],
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'sets selectedAnswerId and wasCorrect=true for correct answer',
        build: () => cubit,
        seed: () => QuizSessionState(
          status: QuizSessionStatus.ready,
          quiz: createQuiz(questions: [createQuizQuestionAnswer()]),
          currentQuestion: testQuestion,
          currentIndex: 0,
        ),
        act: (c) => c.selectAnswer('a1'),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.selectedAnswerId, 'selectedAnswerId', 'a1')
              .having((s) => s.wasCorrect, 'wasCorrect', true),
        ],
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'sets selectedAnswerId and wasCorrect=false for wrong answer',
        build: () => cubit,
        seed: () => QuizSessionState(
          status: QuizSessionStatus.ready,
          quiz: createQuiz(questions: [createQuizQuestionAnswer()]),
          currentQuestion: testQuestion,
          currentIndex: 0,
        ),
        act: (c) => c.selectAnswer('a2'),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.selectedAnswerId, 'selectedAnswerId', 'a2')
              .having((s) => s.wasCorrect, 'wasCorrect', false),
        ],
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'does nothing when already answered',
        build: () => cubit,
        seed: () => QuizSessionState(
          status: QuizSessionStatus.ready,
          quiz: createQuiz(questions: [createQuizQuestionAnswer()]),
          currentQuestion: testQuestion,
          currentIndex: 0,
          selectedAnswerId: 'a1',
          wasCorrect: true,
        ),
        act: (c) => c.selectAnswer('a2'),
        expect: () => [], // No state change
      );
    });

    group('submitAndNext', () {
      final testQuiz = createQuiz(
        id: 'quiz-1',
        questions: [
          createQuizQuestionAnswer(questionId: 1, orderIndex: 0),
          createQuizQuestionAnswer(questionId: 2, orderIndex: 1),
        ],
      );
      final testQuestion = createQuestion(id: 1);

      blocTest<QuizSessionCubit, QuizSessionState>(
        'submits answer and loads next question',
        build: () {
          when(() => mockSubmitAnswer(
                quizId: any(named: 'quizId'),
                questionId: any(named: 'questionId'),
                selectedAnswerId: any(named: 'selectedAnswerId'),
                wasCorrect: any(named: 'wasCorrect'),
              )).thenAnswer((_) async {});
          when(() => mockQuestionRepository.updateRanking(
                questionId: any(named: 'questionId'),
                wasCorrect: any(named: 'wasCorrect'),
              )).thenAnswer((_) async {});
          when(() => mockQuizRepository.getQuizById(any()))
              .thenAnswer((_) async => testQuiz);
          when(() => mockQuizRepository.updateCurrentIndex(any(), any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        seed: () => QuizSessionState(
          status: QuizSessionStatus.ready,
          quiz: testQuiz,
          currentQuestion: testQuestion,
          currentIndex: 0,
          selectedAnswerId: 'a1',
          wasCorrect: true,
        ),
        act: (c) => c.submitAndNext(),
        verify: (_) {
          verify(() => mockSubmitAnswer(
                quizId: 'quiz-1',
                questionId: 1,
                selectedAnswerId: 'a1',
                wasCorrect: true,
              )).called(1);
          verify(() => mockQuestionRepository.updateRanking(
                questionId: 1,
                wasCorrect: true,
              )).called(1);
        },
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'completes quiz on last question',
        build: () {
          when(() => mockSubmitAnswer(
                quizId: any(named: 'quizId'),
                questionId: any(named: 'questionId'),
                selectedAnswerId: any(named: 'selectedAnswerId'),
                wasCorrect: any(named: 'wasCorrect'),
              )).thenAnswer((_) async {});
          when(() => mockQuestionRepository.updateRanking(
                questionId: any(named: 'questionId'),
                wasCorrect: any(named: 'wasCorrect'),
              )).thenAnswer((_) async {});
          when(() => mockQuizRepository.getQuizById(any()))
              .thenAnswer((_) async => testQuiz);
          when(() => mockCompleteQuiz(any()))
              .thenAnswer((_) async => createQuizResult());
          return cubit;
        },
        seed: () => QuizSessionState(
          status: QuizSessionStatus.ready,
          quiz: testQuiz,
          currentQuestion: testQuestion,
          currentIndex: 1, // Last question (index 1 of 2)
          selectedAnswerId: 'a1',
          wasCorrect: true,
        ),
        act: (c) => c.submitAndNext(),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.submitting),
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.completed),
        ],
        verify: (_) {
          verify(() => mockCompleteQuiz('quiz-1')).called(1);
        },
      );
    });

    group('resumeQuiz', () {
      final testQuiz = createQuiz(
        id: 'quiz-1',
        currentQuestionIndex: 5,
        questions: List.generate(
          10,
          (i) => createQuizQuestionAnswer(questionId: i + 1, orderIndex: i),
        ),
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'loads quiz at saved currentQuestionIndex',
        build: () {
          when(() => mockQuizRepository.getQuizById('quiz-1'))
              .thenAnswer((_) async => testQuiz);
          when(() => mockQuestionRepository.getQuestionsByIds(
                ids: any(named: 'ids'),
              )).thenAnswer((_) async =>
              List.generate(10, (i) => createQuestion(id: i + 1)));
          when(() => mockQuizRepository.updateCurrentIndex(any(), any()))
              .thenAnswer((_) async {});
          return cubit;
        },
        act: (c) => c.resumeQuiz('quiz-1'),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.loading),
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.ready)
              .having((s) => s.currentIndex, 'currentIndex', 5),
        ],
      );

      blocTest<QuizSessionCubit, QuizSessionState>(
        'emits error when quiz not found',
        build: () {
          when(() => mockQuizRepository.getQuizById('invalid'))
              .thenAnswer((_) async => null);
          return cubit;
        },
        act: (c) => c.resumeQuiz('invalid'),
        expect: () => [
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.loading),
          isA<QuizSessionState>()
              .having((s) => s.status, 'status', QuizSessionStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ],
      );
    });

    group('state getters', () {
      test('isLastQuestion returns true on last question', () {
        final state = QuizSessionState(
          quiz: createQuiz(
            questions: createQuizQuestionsList(count: 10),
          ),
          currentIndex: 9,
        );

        expect(state.isLastQuestion, true);
      });

      test('isLastQuestion returns false on non-last question', () {
        final state = QuizSessionState(
          quiz: createQuiz(
            questions: createQuizQuestionsList(count: 10),
          ),
          currentIndex: 5,
        );

        expect(state.isLastQuestion, false);
      });

      test('hasAnswered returns true when selectedAnswerId is set', () {
        const state = QuizSessionState(selectedAnswerId: 'a1');
        expect(state.hasAnswered, true);
      });

      test('hasAnswered returns false when selectedAnswerId is null', () {
        const state = QuizSessionState();
        expect(state.hasAnswered, false);
      });

      test('progress calculates correctly', () {
        final state = QuizSessionState(
          quiz: createQuiz(
            questions: createQuizQuestionsList(count: 10),
          ),
          currentIndex: 4,
        );

        expect(state.progress, 0.5); // (4+1)/10 = 0.5
      });
    });
  });
}
