import 'package:equatable/equatable.dart';

import 'answer.dart';

class Question extends Equatable {
  final int id;
  final String categoryId;
  final String questionText;
  final int points;
  final bool hasImages;
  final List<String> imageRefs;
  final List<Answer> answers;

  const Question({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.points,
    required this.hasImages,
    required this.imageRefs,
    required this.answers,
  });

  @override
  List<Object?> get props => [
        id,
        categoryId,
        questionText,
        points,
        hasImages,
        imageRefs,
        answers,
      ];
}
