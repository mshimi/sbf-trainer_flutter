// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionDto _$QuestionDtoFromJson(Map<String, dynamic> json) => QuestionDto(
  id: (json['id'] as num).toInt(),
  categoryId: json['category_id'] as String,
  questionText: json['question_text'] as String,
  points: (json['points'] as num).toInt(),
  hasImages: json['has_images'] as bool,
  imageRefs: (json['image_refs'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  answers: (json['answers'] as List<dynamic>)
      .map((e) => AnswerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuestionDtoToJson(QuestionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'question_text': instance.questionText,
      'points': instance.points,
      'has_images': instance.hasImages,
      'image_refs': instance.imageRefs,
      'answers': instance.answers,
    };
