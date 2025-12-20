import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../datasources/question_local_datasource.dart';
import '../mapper/question_mapper.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionLocalDataSource _localDataSource;
  final QuestionMapper _mapper;

  QuestionRepositoryImpl(this._localDataSource, this._mapper);

  @override
  Future<bool> hasQuestions() {
    return _localDataSource.hasQuestions();
  }

  @override
  Future<void> seedQuestions(List<Question> questions) {
    return _localDataSource.insertQuestionsWithRankings(questions);
  }

  @override
  Future<int> getQuestionCount() {
    return _localDataSource.getQuestionCount();
  }

  @override
  Future<int> getRankingCount() {
    return _localDataSource.getRankingCount();
  }

  @override
  Future<int> getMasteredQuestionCount(int threshold) {
    return _localDataSource.getMasteredQuestionCount(threshold);
  }

  @override
  Stream<int> watchQuestionCount() {
    return _localDataSource.watchQuestionCount();
  }

  @override
  Stream<int> watchMasteredQuestionCount(int threshold) {
    return _localDataSource.watchMasteredQuestionCount(threshold);
  }

  @override
  Future<List<Question>> getQuestionsPaginated({
    required int limit,
    required int offset,
    List<String>? categoryIds,
  }) async {
    final rows = await _localDataSource.getQuestionsPaginated(
      limit: limit,
      offset: offset,
      categoryIds: categoryIds,
    );
    return rows.map((row) => _mapper.fromDbRow(row)).toList();
  }

  @override
  Future<int> getQuestionCountByCategories(List<String>? categoryIds) {
    return _localDataSource.getQuestionCountByCategories(categoryIds);
  }

  @override
  Future<Map<int, int>> getRankingsForQuestions(List<int> questionIds) {
    return _localDataSource.getRankingsForQuestions(questionIds);
  }

  @override
  Future<void> updateRanking({
    required int questionId,
    required bool wasCorrect,
  }) {
    return _localDataSource.updateRanking(
      questionId: questionId,
      wasCorrect: wasCorrect,
    );
  }

  @override
  Future<List<int>> getRandomQuestionIds({
    required int count,
    List<String>? categoryIds,
  }) {
    return _localDataSource.getRandomQuestionIds(
      count: count,
      categoryIds: categoryIds,
    );
  }

  @override
  Future<List<Question>> getQuestionsByIds({required List<int> ids}) async {

    final rows = await _localDataSource.getQuestionsByIds(ids :ids);

    return rows.map((row) => _mapper.fromDbRow(row)).toList();

  }
}
