import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  void changeTitle() {
    emit(state.copyWith(title: 'Hello from HomeCubit 🚀'));
  }
}
