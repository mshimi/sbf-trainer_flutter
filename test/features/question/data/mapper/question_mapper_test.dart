import 'package:flutter_test/flutter_test.dart';
import 'package:sbf_trainer/features/question/data/dtos/answer_dto.dart';
import 'package:sbf_trainer/features/question/data/dtos/question_dto.dart';
import 'package:sbf_trainer/features/question/data/mapper/question_mapper.dart';

import '../../../../fixtures/db_fixtures.dart';

void main() {
  late QuestionMapper mapper;

  setUp(() {
    mapper = QuestionMapper();
  });

  group('QuestionMapper', () {
    group('fromDbRow', () {
      test('correctly parses JSON fields', () {
        final row = createQuestionRow(
          id: 1,
          categoryId: 'basisfragen',
          questionText: 'What is the answer?',
          points: 2,
          hasImages: true,
          imageRefs: ['image1.png', 'image2.png'],
          answers: [
            {'id': 'a1', 'text': 'Answer 1', 'is_correct': true},
            {'id': 'a2', 'text': 'Answer 2', 'is_correct': false},
          ],
        );

        final question = mapper.fromDbRow(row);

        expect(question.id, 1);
        expect(question.categoryId, 'basisfragen');
        expect(question.questionText, 'What is the answer?');
        expect(question.points, 2);
        expect(question.hasImages, true);
        expect(question.imageRefs, ['image1.png', 'image2.png']);
        expect(question.answers.length, 2);
      });

      test('parses answers correctly', () {
        final row = createQuestionRow(
          answers: [
            {'id': 'a1', 'text': 'Correct', 'is_correct': true},
            {'id': 'a2', 'text': 'Wrong 1', 'is_correct': false},
            {'id': 'a3', 'text': 'Wrong 2', 'is_correct': false},
            {'id': 'a4', 'text': 'Wrong 3', 'is_correct': false},
          ],
        );

        final question = mapper.fromDbRow(row);

        expect(question.answers[0].id, 'a1');
        expect(question.answers[0].text, 'Correct');
        expect(question.answers[0].isCorrect, true);
        expect(question.answers[1].isCorrect, false);
      });

      test('handles empty imageRefs', () {
        final row = createQuestionRow(imageRefs: []);

        final question = mapper.fromDbRow(row);

        expect(question.imageRefs, isEmpty);
      });

      test('handles numeric answer id conversion', () {
        final row = createQuestionRow(
          answers: [
            {'id': 1, 'text': 'Answer', 'is_correct': true},
          ],
        );

        final question = mapper.fromDbRow(row);

        expect(question.answers[0].id, '1');
      });
    });

    group('fromDto', () {
      test('correctly maps DTO to entity', () {
        final dto = QuestionDto(
          id: 1,
          categoryId: 'spezifischbinnen',
          questionText: 'Test question?',
          points: 1,
          hasImages: false,
          imageRefs: [],
          answers: [
            AnswerDto(id: 'a1', text: 'Answer 1', isCorrect: true),
            AnswerDto(id: 'a2', text: 'Answer 2', isCorrect: false),
          ],
        );

        final question = mapper.fromDto(dto);

        expect(question.id, 1);
        expect(question.categoryId, 'spezifischbinnen');
        expect(question.questionText, 'Test question?');
        expect(question.points, 1);
        expect(question.hasImages, false);
        expect(question.imageRefs, isEmpty);
        expect(question.answers.length, 2);
        expect(question.answers[0].id, 'a1');
        expect(question.answers[0].text, 'Answer 1');
        expect(question.answers[0].isCorrect, true);
      });

      test('maps all answer properties', () {
        final dto = QuestionDto(
          id: 1,
          categoryId: 'test',
          questionText: 'Test?',
          points: 1,
          hasImages: false,
          imageRefs: [],
          answers: [
            AnswerDto(id: 'correct', text: 'Correct answer', isCorrect: true),
            AnswerDto(id: 'wrong1', text: 'Wrong 1', isCorrect: false),
            AnswerDto(id: 'wrong2', text: 'Wrong 2', isCorrect: false),
            AnswerDto(id: 'wrong3', text: 'Wrong 3', isCorrect: false),
          ],
        );

        final question = mapper.fromDto(dto);

        final correctAnswer =
            question.answers.firstWhere((a) => a.isCorrect);
        expect(correctAnswer.id, 'correct');
        expect(correctAnswer.text, 'Correct answer');

        final wrongAnswers = question.answers.where((a) => !a.isCorrect);
        expect(wrongAnswers.length, 3);
      });
    });
  });
}
