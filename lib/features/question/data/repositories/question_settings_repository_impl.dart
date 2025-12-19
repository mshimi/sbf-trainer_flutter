import '../../domain/repositories/question_settings_repository.dart';
import '../datasources/question_settings_local_datasource.dart';

class QuestionSettingsRepositoryImpl implements QuestionSettingsRepository {
  final QuestionSettingsLocalDataSource _localDataSource;

  QuestionSettingsRepositoryImpl(this._localDataSource);

  @override
  Future<int> getMasteryThreshold() {
    return _localDataSource.getMasteryThreshold();
  }

  @override
  Future<void> setMasteryThreshold(int value) {
    return _localDataSource.setMasteryThreshold(value);
  }

  @override
  Future<void> initializeDefaultSettings() {
    return _localDataSource.initializeDefaultSettings();
  }
}
