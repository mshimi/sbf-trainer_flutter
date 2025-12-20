import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/question/domain/repositories/question_repository.dart';
import 'package:sbf_trainer/features/question/domain/repositories/question_settings_repository.dart';
import 'package:sbf_trainer/features/quiz/domain/repositories/quiz_repository.dart';

/// Mock implementation of QuestionRepository
class MockQuestionRepository extends Mock implements QuestionRepository {}

/// Mock implementation of QuizRepository
class MockQuizRepository extends Mock implements QuizRepository {}

/// Mock implementation of QuestionSettingsRepository
class MockQuestionSettingsRepository extends Mock
    implements QuestionSettingsRepository {}
