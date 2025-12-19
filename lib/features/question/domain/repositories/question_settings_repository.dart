abstract class QuestionSettingsRepository {
  /// Returns the mastery threshold (times correct to mark as mastered)
  Future<int> getMasteryThreshold();

  /// Sets the mastery threshold
  Future<void> setMasteryThreshold(int value);

  /// Initializes default settings if not present
  Future<void> initializeDefaultSettings();
}
