import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';
import 'quiz_overview_state.dart';

class QuizOverviewCubit extends Cubit<QuizOverviewState> {
  final QuizRepository _quizRepository;

  static const int maxDisplayItems = 5;

  StreamSubscription<List<Quiz>>? _openQuizzesSubscription;
  StreamSubscription<List<Quiz>>? _completedQuizzesSubscription;

  QuizOverviewCubit(this._quizRepository)
      : super(const QuizOverviewState.initial());

  void startWatching() {
    emit(const QuizOverviewState.loading());

    _openQuizzesSubscription?.cancel();
    _completedQuizzesSubscription?.cancel();

    _openQuizzesSubscription = _quizRepository
        .watchOpenQuizzes(limit: maxDisplayItems)
        .listen(
      (openQuizzes) {
        emit(state.copyWith(
          status: QuizOverviewStatus.loaded,
          openQuizzes: openQuizzes,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: QuizOverviewStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );

    _completedQuizzesSubscription = _quizRepository
        .watchCompletedQuizzes(limit: maxDisplayItems)
        .listen(
      (completedQuizzes) {
        emit(state.copyWith(
          status: QuizOverviewStatus.loaded,
          completedQuizzes: completedQuizzes,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          status: QuizOverviewStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _openQuizzesSubscription?.cancel();
    _completedQuizzesSubscription?.cancel();
    return super.close();
  }
}
