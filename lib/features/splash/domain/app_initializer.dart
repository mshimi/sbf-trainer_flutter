
abstract class AppInitializer {
  /// Returns true if the app is already initialized (DB seeded, migrations done, etc.)
  Future<bool> isInitialized();

  /// Perform initialization (e.g. create/open DB, seed questions from assets, migrations)
  Future<void> initialize();
}
