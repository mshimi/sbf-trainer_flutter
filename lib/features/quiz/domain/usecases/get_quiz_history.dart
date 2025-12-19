import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class GetQuizHistory {
  final QuizRepository _repository;

  GetQuizHistory(this._repository);

  Future<List<Quiz>> call({
    QuizType? type,
    int? limit,
    int? offset,
  }) {
    return _repository.getQuizHistory(
      type: type,
      limit: limit,
      offset: offset,
    );
  }

  Stream<List<Quiz>> watch({int? limit}) {
    return _repository.watchQuizHistory(limit: limit);
  }
}
