import 'package:get_it/get_it.dart';

import '../../features/question/data/datasources/question_local_datasource.dart';
import '../../features/question/data/datasources/question_settings_local_datasource.dart';
import '../../features/question/data/mapper/question_mapper.dart';
import '../../features/question/data/repositories/question_repository_impl.dart';
import '../../features/question/data/repositories/question_settings_repository_impl.dart';
import '../../features/question/domain/repositories/question_repository.dart';
import '../../features/question/domain/repositories/question_settings_repository.dart';
import '../../features/question/domain/usecases/get_mastery_stats.dart';
import '../../features/quiz/data/datasources/quiz_local_datasource.dart';
import '../../features/quiz/data/mappers/quiz_mapper.dart';
import '../../features/quiz/data/repositories/quiz_repository_impl.dart';
import '../../features/quiz/domain/repositories/quiz_repository.dart';
import '../../features/quiz/domain/usecases/complete_quiz.dart';
import '../../features/quiz/domain/usecases/get_quiz_history.dart';
import '../../features/quiz/domain/usecases/get_resumable_quizzes.dart';
import '../../features/quiz/domain/usecases/start_quiz.dart';
import '../../features/quiz/domain/usecases/submit_answer.dart';
import '../../features/quiz/presentation/cubit/quiz_history_cubit.dart';
import '../../features/quiz/presentation/cubit/quiz_overview_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/splash/data/app_initializer_impl.dart';
import '../../features/splash/domain/app_initializer.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../db/app_database.dart';

void registerFeatures(GetIt getIt) {
  // Question
  getIt.registerLazySingleton<QuestionMapper>(() => QuestionMapper());
  getIt.registerLazySingleton<QuestionLocalDataSource>(
    () => QuestionLocalDataSourceImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(
      getIt<QuestionLocalDataSource>(),
      getIt<QuestionMapper>(),
    ),
  );

  // Question Settings
  getIt.registerLazySingleton<QuestionSettingsLocalDataSource>(
    () => QuestionSettingsLocalDataSourceImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<QuestionSettingsRepository>(
    () => QuestionSettingsRepositoryImpl(getIt<QuestionSettingsLocalDataSource>()),
  );

  // Question Usecases
  getIt.registerLazySingleton<GetMasteryStats>(
    () => GetMasteryStats(
      getIt<QuestionRepository>(),
      getIt<QuestionSettingsRepository>(),
    ),
  );

  // Quiz
  getIt.registerLazySingleton<QuizMapper>(() => QuizMapper());
  getIt.registerLazySingleton<QuizLocalDataSource>(
    () => QuizLocalDataSourceImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      getIt<QuizLocalDataSource>(),
      getIt<QuestionLocalDataSource>(),
      getIt<QuizMapper>(),
      getIt<QuestionMapper>(),
    ),
  );

  // Quiz Usecases
  getIt.registerLazySingleton<StartQuiz>(
    () => StartQuiz(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton<SubmitAnswer>(
    () => SubmitAnswer(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton<CompleteQuiz>(
    () => CompleteQuiz(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton<GetQuizHistory>(
    () => GetQuizHistory(getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton<GetResumableQuizzes>(
    () => GetResumableQuizzes(getIt<QuizRepository>()),
  );

  // Quiz Cubits
  getIt.registerFactory(
    () => QuizOverviewCubit(getIt<QuizRepository>()),
  );
  getIt.registerFactory(
    () => QuizHistoryCubit(getIt<GetQuizHistory>()),
  );

  // Splash
  getIt.registerLazySingleton<AppInitializer>(
    () => AppInitializerImpl(
      getIt<QuestionRepository>(),
      getIt<QuestionMapper>(),
      getIt<QuestionSettingsRepository>(),
    ),
  );
  getIt.registerFactory(() => SplashCubit(getIt<AppInitializer>()));

  // Settings
  getIt.registerFactory(
    () => SettingsCubit(
      settingsRepository: getIt<QuestionSettingsRepository>(),
      database: getIt<AppDatabase>(),
      appInitializer: getIt<AppInitializer>(),
    ),
  );
}
