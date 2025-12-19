import 'package:equatable/equatable.dart';

class MasteryStats extends Equatable {
  final int totalQuestions;
  final int masteredQuestions;

  const MasteryStats({
    required this.totalQuestions,
    required this.masteredQuestions,
  });

  double get progressPercentage =>
      totalQuestions > 0 ? masteredQuestions / totalQuestions : 0.0;

  @override
  List<Object?> get props => [totalQuestions, masteredQuestions];
}
