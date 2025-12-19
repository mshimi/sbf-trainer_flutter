import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/app_initializer.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AppInitializer _initializer;

  SplashCubit(this._initializer) : super(const SplashState.checking());

  Future<void> start() async {
    emit(const SplashState.checking());

    final already = await _initializer.isInitialized();
    if (already) {
      emit(const SplashState.alreadyInitialized());
      return;
    }

    emit(const SplashState.initializing());
    await _initializer.initialize();
    emit(const SplashState.completed());
  }
}
