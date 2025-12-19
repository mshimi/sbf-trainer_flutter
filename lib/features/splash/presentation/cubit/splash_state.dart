import 'package:equatable/equatable.dart';

enum SplashStatus {
  checkingAppState,
  initializing,
  initCompleted,
  alreadyInitialized,
}

class SplashState extends Equatable {
  final SplashStatus status;

  const SplashState({required this.status});

  const SplashState.checking() : status = SplashStatus.checkingAppState;
  const SplashState.initializing() : status = SplashStatus.initializing;
  const SplashState.completed() : status = SplashStatus.initCompleted;
  const SplashState.alreadyInitialized() : status = SplashStatus.alreadyInitialized;

  @override
  List<Object?> get props => [status];
}
