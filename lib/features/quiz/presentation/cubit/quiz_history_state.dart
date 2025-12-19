import 'package:equatable/equatable.dart';

import '../../domain/entities/quiz.dart';

enum QuizHistoryStatus { initial, loading, loaded, loadingMore, error }

enum QuizHistoryFilter { all, open, completed }

class QuizHistoryState extends Equatable {
  final QuizHistoryStatus status;
  final List<Quiz> quizzes;
  final QuizHistoryFilter filter;
  final bool hasReachedEnd;
  final int currentPage;
  final String? errorMessage;

  static const int pageSize = 10;

  const QuizHistoryState({
    this.status = QuizHistoryStatus.initial,
    this.quizzes = const [],
    this.filter = QuizHistoryFilter.all,
    this.hasReachedEnd = false,
    this.currentPage = 0,
    this.errorMessage,
  });

  const QuizHistoryState.initial() : this();

  List<Quiz> get filteredQuizzes {
    switch (filter) {
      case QuizHistoryFilter.all:
        return quizzes;
      case QuizHistoryFilter.open:
        return quizzes
            .where((q) => q.status == QuizStatus.inProgress)
            .toList();
      case QuizHistoryFilter.completed:
        return quizzes
            .where((q) =>
                q.status == QuizStatus.completed ||
                q.status == QuizStatus.abandoned)
            .toList();
    }
  }

  List<Quiz> get openQuizzes =>
      quizzes.where((q) => q.status == QuizStatus.inProgress).toList();

  List<Quiz> get completedQuizzes =>
      quizzes
          .where((q) =>
              q.status == QuizStatus.completed ||
              q.status == QuizStatus.abandoned)
          .toList();

  QuizHistoryState copyWith({
    QuizHistoryStatus? status,
    List<Quiz>? quizzes,
    QuizHistoryFilter? filter,
    bool? hasReachedEnd,
    int? currentPage,
    String? errorMessage,
  }) {
    return QuizHistoryState(
      status: status ?? this.status,
      quizzes: quizzes ?? this.quizzes,
      filter: filter ?? this.filter,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quizzes,
        filter,
        hasReachedEnd,
        currentPage,
        errorMessage,
      ];
}
