import 'package:sbf_trainer/features/question/domain/entities/answer.dart';
import 'package:sbf_trainer/features/question/domain/entities/question.dart';
import 'package:sbf_trainer/features/question/domain/entities/mastery_stats.dart';

/// Creates a sample Answer with customizable properties
Answer createAnswer({
  String id = 'a1',
  String text = 'Answer text',
  bool isCorrect = false,
}) {
  return Answer(
    id: id,
    text: text,
    isCorrect: isCorrect,
  );
}

/// Creates a sample Question with customizable properties
Question createQuestion({
  int id = 1,
  String categoryId = 'basisfragen',
  String questionText = 'Sample question?',
  int points = 1,
  bool hasImages = false,
  List<String> imageRefs = const [],
  List<Answer>? answers,
}) {
  return Question(
    id: id,
    categoryId: categoryId,
    questionText: questionText,
    points: points,
    hasImages: hasImages,
    imageRefs: imageRefs,
    answers: answers ??
        [
          createAnswer(id: 'a1', text: 'Correct answer', isCorrect: true),
          createAnswer(id: 'a2', text: 'Wrong answer 1', isCorrect: false),
          createAnswer(id: 'a3', text: 'Wrong answer 2', isCorrect: false),
          createAnswer(id: 'a4', text: 'Wrong answer 3', isCorrect: false),
        ],
  );
}

/// Creates a sample MasteryStats with customizable properties
MasteryStats createMasteryStats({
  int totalQuestions = 300,
  int masteredQuestions = 0,
}) {
  return MasteryStats(
    totalQuestions: totalQuestions,
    masteredQuestions: masteredQuestions,
  );
}

/// Creates a list of sample questions for testing
List<Question> createQuestionList({
  int count = 10,
  String categoryId = 'basisfragen',
  int startId = 1,
}) {
  return List.generate(
    count,
    (index) => createQuestion(
      id: startId + index,
      categoryId: categoryId,
      questionText: 'Question ${startId + index}?',
    ),
  );
}

/// Creates questions for different categories (motor exam simulation)
List<Question> createMotorExamQuestions() {
  return [
    // 7 Basisfragen
    ...createQuestionList(count: 7, categoryId: 'basisfragen', startId: 1),
    // 23 Spezifisch Binnen
    ...createQuestionList(count: 23, categoryId: 'spezifischbinnen', startId: 8),
  ];
}

/// Creates questions for sailing only exam simulation
List<Question> createSailingOnlyExamQuestions() {
  return [
    // 7 Basisfragen
    ...createQuestionList(count: 7, categoryId: 'basisfragen', startId: 1),
    // 18 Spezifisch Segeln
    ...createQuestionList(count: 18, categoryId: 'spezifischsegeln', startId: 8),
  ];
}
