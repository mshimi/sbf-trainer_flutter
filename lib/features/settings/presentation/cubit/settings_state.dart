import 'package:equatable/equatable.dart';

enum SettingsStatus { initial, loading, loaded, saving, error }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final int masteryThreshold;
  final String? errorMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.masteryThreshold = 3,
    this.errorMessage,
  });

  const SettingsState.initial() : this();

  SettingsState copyWith({
    SettingsStatus? status,
    int? masteryThreshold,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      masteryThreshold: masteryThreshold ?? this.masteryThreshold,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, masteryThreshold, errorMessage];
}
