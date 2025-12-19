import 'package:equatable/equatable.dart';

class QuizQuestionAnswer extends Equatable {
  final int questionId;
  final int orderIndex;
  final List<String> shuffledAnswerIds;
  final String? selectedAnswerId;
  final bool? wasCorrect;
  final int points;
  final DateTime? answeredAt;

  const QuizQuestionAnswer({
    required this.questionId,
    required this.orderIndex,
    required this.shuffledAnswerIds,
    this.selectedAnswerId,
    this.wasCorrect,
    required this.points,
    this.answeredAt,
  });

  bool get isAnswered => selectedAnswerId != null;

  QuizQuestionAnswer copyWith({
    int? questionId,
    int? orderIndex,
    List<String>? shuffledAnswerIds,
    String? selectedAnswerId,
    bool? wasCorrect,
    int? points,
    DateTime? answeredAt,
  }) {
    return QuizQuestionAnswer(
      questionId: questionId ?? this.questionId,
      orderIndex: orderIndex ?? this.orderIndex,
      shuffledAnswerIds: shuffledAnswerIds ?? this.shuffledAnswerIds,
      selectedAnswerId: selectedAnswerId ?? this.selectedAnswerId,
      wasCorrect: wasCorrect ?? this.wasCorrect,
      points: points ?? this.points,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  List<Object?> get props => [
        questionId,
        orderIndex,
        shuffledAnswerIds,
        selectedAnswerId,
        wasCorrect,
        points,
        answeredAt,
      ];
}
