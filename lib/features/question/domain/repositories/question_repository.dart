import '../entities/question.dart';

abstract class QuestionRepository {
  /// Returns true if questions exist in the database
  Future<bool> hasQuestions();

  /// Loads questions from JSON asset and saves them to database with rankings
  Future<void> seedQuestions(List<Question> questions);

  /// Returns the total number of questions in the database
  Future<int> getQuestionCount();

  /// Returns the total number of rankings in the database
  Future<int> getRankingCount();

  /// Returns the count of mastered questions (timesCorrect >= threshold)
  Future<int> getMasteredQuestionCount(int threshold);

  /// Watches question count changes
  Stream<int> watchQuestionCount();

  /// Watches mastered question count changes
  Stream<int> watchMasteredQuestionCount(int threshold);

  /// Returns paginated questions with optional category filter
  Future<List<Question>> getQuestionsPaginated({
    required int limit,
    required int offset,
    List<String>? categoryIds,
  });


  Future<List<Question>> getQuestionsByIds({
    required List<int> ids
});

  /// Returns total count of questions for given categories
  Future<int> getQuestionCountByCategories(List<String>? categoryIds);

  /// Returns map of questionId -> timesCorrect for given question IDs
  Future<Map<int, int>> getRankingsForQuestions(List<int> questionIds);

  /// Updates the ranking for a question based on answer correctness
  /// If correct: increment timesCorrect by 1
  /// If wrong: reset timesCorrect to 0
  Future<void> updateRanking({
    required int questionId,
    required bool wasCorrect,
  });

  /// Returns random question IDs for custom quizzes
  Future<List<int>> getRandomQuestionIds({
    required int count,
    List<String>? categoryIds,
  });
}
