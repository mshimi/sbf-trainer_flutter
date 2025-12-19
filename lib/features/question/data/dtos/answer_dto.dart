import 'package:json_annotation/json_annotation.dart';

part 'answer_dto.g.dart';

@JsonSerializable()
class AnswerDto {
  final String id;
  final String text;
  @JsonKey(name: 'is_correct')
  final bool isCorrect;

  const AnswerDto({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory AnswerDto.fromJson(Map<String, dynamic> json) =>
      _$AnswerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerDtoToJson(this);
}
