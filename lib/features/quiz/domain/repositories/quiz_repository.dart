import '../entities/quiz.dart';
import '../entities/quiz_result.dart';

abstract class QuizRepository {
  /// Creates a new quiz session and returns the quiz with shuffled questions
  Future<Quiz> createQuiz({
    required QuizType type,
    int? examSheetIndex,
    List<int>? customQuestionIds,
  });

  /// Gets a quiz by ID with all questions
  Future<Quiz?> getQuizById(String id);

  /// Records a user's answer for a question
  Future<void> submitAnswer({
    required String quizId,
    required int questionId,
    required String selectedAnswerId,
    required bool wasCorrect,
  });

  /// Updates the current question index for resumable quizzes
  Future<void> updateCurrentIndex(String quizId, int index);

  /// Marks quiz as completed and calculates final results
  Future<QuizResult> completeQuiz(String quizId);

  /// Marks quiz as abandoned
  Future<void> abandonQuiz(String quizId);

  /// Gets all quizzes (for history), optionally filtered by type
  Future<List<Quiz>> getQuizHistory({
    QuizType? type,
    int? limit,
    int? offset,
  });

  /// Gets incomplete quizzes that can be resumed
  Future<List<Quiz>> getResumableQuizzes();

  /// Watches quiz history for updates
  Stream<List<Quiz>> watchQuizHistory({int? limit});

  /// Watches open (in-progress) quizzes
  Stream<List<Quiz>> watchOpenQuizzes({int? limit});

  /// Watches completed quizzes (completed + abandoned)
  Stream<List<Quiz>> watchCompletedQuizzes({int? limit});

  /// Deletes a quiz by ID
  Future<void> deleteQuiz(String quizId);
}
