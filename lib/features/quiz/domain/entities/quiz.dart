import 'package:equatable/equatable.dart';

import 'quiz_question_answer.dart';

enum QuizType { motor, sailingOnly, combined, custom }

enum QuizStatus { inProgress, completed, abandoned }

class Quiz extends Equatable {
  final String id;
  final QuizType type;
  final int? examSheetIndex;
  final DateTime startedAt;
  final DateTime? endedAt;
  final QuizStatus status;
  final List<QuizQuestionAnswer> questions;
  final int currentQuestionIndex;

  const Quiz({
    required this.id,
    required this.type,
    this.examSheetIndex,
    required this.startedAt,
    this.endedAt,
    required this.status,
    required this.questions,
    required this.currentQuestionIndex,
  });

  int get totalQuestions => questions.length;

  int get answeredCount =>
      questions.where((q) => q.selectedAnswerId != null).length;

  int get correctCount => questions.where((q) => q.wasCorrect == true).length;

  int get totalPoints => questions.fold(0, (sum, q) => sum + q.points);

  int get earnedPoints => questions
      .where((q) => q.wasCorrect == true)
      .fold(0, (sum, q) => sum + q.points);

  bool get isComplete => status == QuizStatus.completed;

  bool get canResume => status == QuizStatus.inProgress;

  double get progressPercentage =>
      totalQuestions > 0 ? answeredCount / totalQuestions : 0;

  Quiz copyWith({
    String? id,
    QuizType? type,
    int? examSheetIndex,
    DateTime? startedAt,
    DateTime? endedAt,
    QuizStatus? status,
    List<QuizQuestionAnswer>? questions,
    int? currentQuestionIndex,
  }) {
    return Quiz(
      id: id ?? this.id,
      type: type ?? this.type,
      examSheetIndex: examSheetIndex ?? this.examSheetIndex,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        examSheetIndex,
        startedAt,
        endedAt,
        status,
        questions,
        currentQuestionIndex,
      ];
}
