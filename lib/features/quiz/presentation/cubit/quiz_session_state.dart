import 'package:equatable/equatable.dart';

import '../../../question/domain/entities/question.dart';
import '../../domain/entities/quiz.dart';

enum QuizSessionStatus {
  initial,
  loading,
  ready,
  submitting,
  completed,
  error,
}

class QuizSessionState extends Equatable {
  final QuizSessionStatus status;
  final Quiz? quiz;
  final int currentIndex;
  final Question? currentQuestion;
  final List<String>? shuffledAnswerIds;
  final String? selectedAnswerId;
  final bool? wasCorrect;
  final String? errorMessage;

  const QuizSessionState({
    this.status = QuizSessionStatus.initial,
    this.quiz,
    this.currentIndex = 0,
    this.currentQuestion,
    this.shuffledAnswerIds,
    this.selectedAnswerId,
    this.wasCorrect,
    this.errorMessage,
  });

  const QuizSessionState.initial() : this();

  bool get isLastQuestion =>
      quiz != null && currentIndex >= quiz!.totalQuestions - 1;

  bool get hasAnswered => selectedAnswerId != null;

  int get answeredCount => quiz?.answeredCount ?? 0;

  int get totalQuestions => quiz?.totalQuestions ?? 0;

  double get progress =>
      totalQuestions > 0 ? (currentIndex + 1) / totalQuestions : 0;

  QuizSessionState copyWith({
    QuizSessionStatus? status,
    Quiz? quiz,
    int? currentIndex,
    Question? currentQuestion,
    List<String>? shuffledAnswerIds,
    String? selectedAnswerId,
    bool? wasCorrect,
    String? errorMessage,
    bool clearSelection = false,
  }) {
    return QuizSessionState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      currentIndex: currentIndex ?? this.currentIndex,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      shuffledAnswerIds: shuffledAnswerIds ?? this.shuffledAnswerIds,
      selectedAnswerId:
          clearSelection ? null : (selectedAnswerId ?? this.selectedAnswerId),
      wasCorrect: clearSelection ? null : (wasCorrect ?? this.wasCorrect),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quiz,
        currentIndex,
        currentQuestion,
        shuffledAnswerIds,
        selectedAnswerId,
        wasCorrect,
        errorMessage,
      ];
}
