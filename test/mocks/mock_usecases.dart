import 'package:mocktail/mocktail.dart';
import 'package:sbf_trainer/features/question/domain/usecases/get_mastery_stats.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/start_quiz.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/submit_answer.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/complete_quiz.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/get_quiz_history.dart';
import 'package:sbf_trainer/features/quiz/domain/usecases/get_resumable_quizzes.dart';

/// Mock implementation of GetMasteryStats use case
class MockGetMasteryStats extends Mock implements GetMasteryStats {}

/// Mock implementation of StartQuiz use case
class MockStartQuiz extends Mock implements StartQuiz {}

/// Mock implementation of SubmitAnswer use case
class MockSubmitAnswer extends Mock implements SubmitAnswer {}

/// Mock implementation of CompleteQuiz use case
class MockCompleteQuiz extends Mock implements CompleteQuiz {}

/// Mock implementation of GetQuizHistory use case
class MockGetQuizHistory extends Mock implements GetQuizHistory {}

/// Mock implementation of GetResumableQuizzes use case
class MockGetResumableQuizzes extends Mock implements GetResumableQuizzes {}
