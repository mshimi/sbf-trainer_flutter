import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String title;

  const HomeState({required this.title});

  factory HomeState.initial() {
    return const HomeState(title: 'Hello World');
  }

  HomeState copyWith({String? title}) {
    return HomeState(
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => [title];
}
