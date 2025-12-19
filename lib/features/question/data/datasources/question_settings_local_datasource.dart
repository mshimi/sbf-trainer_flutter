import '../../../../core/db/app_database.dart';

const String kMasteryThresholdKey = 'mastery_threshold';
const int kDefaultMasteryThreshold = 3;

abstract class QuestionSettingsLocalDataSource {
  Future<int> getMasteryThreshold();
  Future<void> setMasteryThreshold(int value);
  Future<void> initializeDefaultSettings();
}

class QuestionSettingsLocalDataSourceImpl
    implements QuestionSettingsLocalDataSource {
  final AppDatabase _db;

  QuestionSettingsLocalDataSourceImpl(this._db);

  @override
  Future<int> getMasteryThreshold() async {
    final result = await (_db.select(_db.questionSettings)
          ..where((t) => t.key.equals(kMasteryThresholdKey)))
        .getSingleOrNull();
    return result?.value ?? kDefaultMasteryThreshold;
  }

  @override
  Future<void> setMasteryThreshold(int value) async {
    await _db.into(_db.questionSettings).insertOnConflictUpdate(
          QuestionSettingsCompanion.insert(
            key: kMasteryThresholdKey,
            value: value,
          ),
        );
  }

  @override
  Future<void> initializeDefaultSettings() async {
    final existing = await (_db.select(_db.questionSettings)
          ..where((t) => t.key.equals(kMasteryThresholdKey)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.questionSettings).insert(
            QuestionSettingsCompanion.insert(
              key: kMasteryThresholdKey,
              value: kDefaultMasteryThreshold,
            ),
          );
    }
  }
}
