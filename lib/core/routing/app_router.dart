import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../di/di.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/question/domain/entities/question.dart';
import '../../features/question/domain/repositories/question_repository.dart';
import '../../features/question/presentation/pages/question_detail_page.dart';
import '../../features/question/presentation/pages/questions_page.dart';
import '../../features/quiz/domain/entities/quiz.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/usecases/complete_quiz.dart';
import '../../features/quiz/domain/usecases/get_quiz_history.dart';
import '../../features/quiz/domain/usecases/start_quiz.dart';
import '../../features/quiz/domain/usecases/submit_answer.dart';
import '../../features/quiz/presentation/cubit/quiz_history_cubit.dart';
import '../../features/quiz/presentation/cubit/quiz_session_cubit.dart';
import '../../features/quiz/presentation/pages/quiz_history_page.dart';
import '../../features/quiz/presentation/pages/quiz_page.dart';
import '../../features/quiz/presentation/pages/quizzes_page.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => BlocProvider(
        create: (context) => getIt<SettingsCubit>(),
        child: const SettingsPage(),
      ),
    ),
    GoRoute(
      path: Routes.quizzes,
      builder: (context, state) => const QuizzesPage(),
    ),
    GoRoute(
      path: Routes.quizHistory,
      builder: (context, state) => BlocProvider(
        create: (context) => QuizHistoryCubit(getIt<GetQuizHistory>()),
        child: const QuizHistoryPage(),
      ),
    ),
    GoRoute(
      path: Routes.quizSession,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final quizId = extra['quizId'] as String?;
        final quizType = extra['quizType'] as QuizType?;
        final examSheetIndex = extra['examSheetIndex'] as int?;
        final customQuestionIds = extra['customQuestionIds'] as List<int>?;

        final cubit = QuizSessionCubit(
          startQuiz: getIt<StartQuiz>(),
          submitAnswer: getIt<SubmitAnswer>(),
          completeQuiz: getIt<CompleteQuiz>(),
          quizRepository: getIt<QuizRepository>(),
          questionRepository: getIt<QuestionRepository>(),
        );

        // Resume existing quiz or start new one
        if (quizId != null) {
          cubit.resumeQuiz(quizId);
        } else if (quizType != null) {
          cubit.startNewQuiz(
            type: quizType,
            examSheetIndex: examSheetIndex,
            customQuestionIds: customQuestionIds,
          );
        }

        return BlocProvider(
          create: (context) => cubit,
          child: const QuizPage(),
        );
      },
    ),
    GoRoute(
      path: Routes.questions,
      builder: (context, state) => const QuestionsPage(),
    ),
    GoRoute(
      path: Routes.questionDetail,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return QuestionDetailPage(
          question: extra['question'] as Question,
          timesCorrect: extra['timesCorrect'] as int,
          masteryThreshold: extra['masteryThreshold'] as int,
        );
      },
    ),
  ],
);
