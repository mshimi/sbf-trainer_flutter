import '../repositories/quiz_repository.dart';

class SubmitAnswer {
  final QuizRepository _repository;

  SubmitAnswer(this._repository);

  Future<void> call({
    required String quizId,
    required int questionId,
    required String selectedAnswerId,
    required bool wasCorrect,
  }) {
    return _repository.submitAnswer(
      quizId: quizId,
      questionId: questionId,
      selectedAnswerId: selectedAnswerId,
      wasCorrect: wasCorrect,
    );
  }
}
