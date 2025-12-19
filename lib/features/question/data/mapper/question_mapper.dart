import 'dart:convert';

import '../../../../core/db/app_database.dart' as db;
import '../../domain/entities/answer.dart';
import '../../domain/entities/question.dart';
import '../dtos/answer_dto.dart';
import '../dtos/question_dto.dart';

class QuestionMapper {
  Question fromDto(QuestionDto dto) {
    return Question(
      id: dto.id,
      categoryId: dto.categoryId,
      questionText: dto.questionText,
      points: dto.points,
      hasImages: dto.hasImages,
      imageRefs: dto.imageRefs,
      answers: dto.answers.map(_answerFromDto).toList(),
    );
  }

  Question fromDbRow(db.Question row) {
    final imageRefs = (jsonDecode(row.imageRefsJson) as List<dynamic>)
        .map((e) => e as String)
        .toList();

    final answersJson = jsonDecode(row.answersJson) as List<dynamic>;
    final answers = answersJson.map((a) {
      final map = a as Map<String, dynamic>;
      return Answer(
        id: map['id'].toString(),
        text: map['text'] as String,
        isCorrect: map['is_correct'] as bool,
      );
    }).toList();

    return Question(
      id: row.id,
      categoryId: row.categoryId,
      questionText: row.questionText,
      points: row.points,
      hasImages: row.hasImages,
      imageRefs: imageRefs,
      answers: answers,
    );
  }

  Answer _answerFromDto(AnswerDto dto) {
    return Answer(
      id: dto.id,
      text: dto.text,
      isCorrect: dto.isCorrect,
    );
  }
}
