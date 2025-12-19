import 'package:equatable/equatable.dart';

import '../../domain/entities/quiz.dart';

enum QuizOverviewStatus { initial, loading, loaded, error }

class QuizOverviewState extends Equatable {
  final QuizOverviewStatus status;
  final List<Quiz> openQuizzes;
  final List<Quiz> completedQuizzes;
  final String? errorMessage;

  const QuizOverviewState({
    this.status = QuizOverviewStatus.initial,
    this.openQuizzes = const [],
    this.completedQuizzes = const [],
    this.errorMessage,
  });

  const QuizOverviewState.initial() : this();

  const QuizOverviewState.loading()
      : this(status: QuizOverviewStatus.loading);

  QuizOverviewState copyWith({
    QuizOverviewStatus? status,
    List<Quiz>? openQuizzes,
    List<Quiz>? completedQuizzes,
    String? errorMessage,
  }) {
    return QuizOverviewState(
      status: status ?? this.status,
      openQuizzes: openQuizzes ?? this.openQuizzes,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get hasQuizzes => openQuizzes.isNotEmpty || completedQuizzes.isNotEmpty;

  @override
  List<Object?> get props => [
        status,
        openQuizzes,
        completedQuizzes,
        errorMessage,
      ];
}
