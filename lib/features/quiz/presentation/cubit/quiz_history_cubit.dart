import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_quiz_history.dart';
import 'quiz_history_state.dart';

class QuizHistoryCubit extends Cubit<QuizHistoryState> {
  final GetQuizHistory _getQuizHistory;

  QuizHistoryCubit(this._getQuizHistory)
      : super(const QuizHistoryState.initial());

  Future<void> loadInitial() async {
    emit(state.copyWith(status: QuizHistoryStatus.loading));

    try {
      final quizzes = await _getQuizHistory(
        limit: QuizHistoryState.pageSize,
        offset: 0,
      );

      emit(state.copyWith(
        status: QuizHistoryStatus.loaded,
        quizzes: quizzes,
        currentPage: 0,
        hasReachedEnd: quizzes.length < QuizHistoryState.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QuizHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.status == QuizHistoryStatus.loadingMore || state.hasReachedEnd) {
      return;
    }

    emit(state.copyWith(status: QuizHistoryStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final offset = nextPage * QuizHistoryState.pageSize;

      final moreQuizzes = await _getQuizHistory(
        limit: QuizHistoryState.pageSize,
        offset: offset,
      );

      emit(state.copyWith(
        status: QuizHistoryStatus.loaded,
        quizzes: [...state.quizzes, ...moreQuizzes],
        currentPage: nextPage,
        hasReachedEnd: moreQuizzes.length < QuizHistoryState.pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: QuizHistoryStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void setFilter(QuizHistoryFilter filter) {
    emit(state.copyWith(filter: filter));
  }

  Future<void> refresh() async {
    emit(state.copyWith(
      status: QuizHistoryStatus.loading,
      quizzes: [],
      currentPage: 0,
      hasReachedEnd: false,
    ));
    await loadInitial();
  }
}
