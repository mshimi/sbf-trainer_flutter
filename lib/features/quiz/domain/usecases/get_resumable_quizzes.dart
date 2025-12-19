import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetResumableQuizzes {
  final QuizRepository _repository;

  GetResumableQuizzes(this._repository);

  Future<List<Quiz>> call() {
    return _repository.getResumableQuizzes();
  }
}
