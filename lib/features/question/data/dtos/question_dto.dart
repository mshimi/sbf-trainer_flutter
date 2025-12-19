import 'package:json_annotation/json_annotation.dart';

import 'answer_dto.dart';

part 'question_dto.g.dart';

@JsonSerializable()
class QuestionDto {
  final int id;
  @JsonKey(name: 'category_id')
  final String categoryId;
  @JsonKey(name: 'question_text')
  final String questionText;
  final int points;
  @JsonKey(name: 'has_images')
  final bool hasImages;
  @JsonKey(name: 'image_refs')
  final List<String> imageRefs;
  final List<AnswerDto> answers;

  const QuestionDto({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.points,
    required this.hasImages,
    required this.imageRefs,
    required this.answers,
  });

  factory QuestionDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionDtoToJson(this);
}
