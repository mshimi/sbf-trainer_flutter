import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/db/app_database.dart';
import '../../../question/domain/repositories/question_settings_repository.dart';
import '../../../splash/domain/app_initializer.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final QuestionSettingsRepository _settingsRepository;
  final AppDatabase _database;
  final AppInitializer _appInitializer;

  SettingsCubit({
    required QuestionSettingsRepository settingsRepository,
    required AppDatabase database,
    required AppInitializer appInitializer,
  })  : _settingsRepository = settingsRepository,
        _database = database,
        _appInitializer = appInitializer,
        super(const SettingsState.initial());

  Future<void> loadSettings() async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      final threshold = await _settingsRepository.getMasteryThreshold();
      emit(state.copyWith(
        status: SettingsStatus.loaded,
        masteryThreshold: threshold,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> setMasteryThreshold(int value) async {
    if (value < 1 || value > 10) return;

    emit(state.copyWith(status: SettingsStatus.saving));

    try {
      await _settingsRepository.setMasteryThreshold(value);
      emit(state.copyWith(
        status: SettingsStatus.loaded,
        masteryThreshold: value,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> resetProgress() async {
    emit(state.copyWith(status: SettingsStatus.saving));

    try {
      await _database.resetProgress();
      emit(state.copyWith(status: SettingsStatus.loaded));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> resetApp() async {
    emit(state.copyWith(status: SettingsStatus.saving));

    try {
      // Clear all data
      await _database.clearAllData();
      // Reinitialize the app (seed questions, settings)
      await _appInitializer.initialize();
      // Reload settings
      final threshold = await _settingsRepository.getMasteryThreshold();
      emit(state.copyWith(
        status: SettingsStatus.loaded,
        masteryThreshold: threshold,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
