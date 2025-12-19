import '../entities/quiz.dart';
import '../repositories/quiz_repository.dart';

class StartQuiz {
  final QuizRepository _repository;

  StartQuiz(this._repository);

  Future<Quiz> call({
    required QuizType type,
    int? examSheetIndex,
    List<int>? customQuestionIds,
  }) {
    return _repository.createQuiz(
      type: type,
      examSheetIndex: examSheetIndex,
      customQuestionIds: customQuestionIds,
    );
  }
}
