import '../entities/quiz_result.dart';
import '../repositories/quiz_repository.dart';

class CompleteQuiz {
  final QuizRepository _repository;

  CompleteQuiz(this._repository);

  Future<QuizResult> call(String quizId) {
    return _repository.completeQuiz(quizId);
  }
}
