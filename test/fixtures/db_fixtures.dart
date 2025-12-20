import 'dart:convert';

import 'package:sbf_trainer/core/db/app_database.dart';

/// Creates a sample Quizze database row
Quizze createQuizzeRow({
  String id = 'quiz-1',
  String quizType = 'motor',
  int? examSheetIndex,
  DateTime? startedAt,
  DateTime? endedAt,
  String status = 'in_progress',
  int totalQuestions = 30,
  int correctAnswers = 0,
  int totalPoints = 30,
  int earnedPoints = 0,
  bool? passed,
  int currentQuestionIndex = 0,
}) {
  return Quizze(
    id: id,
    quizType: quizType,
    examSheetIndex: examSheetIndex,
    startedAt: startedAt ?? DateTime.now(),
    endedAt: endedAt,
    status: status,
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    totalPoints: totalPoints,
    earnedPoints: earnedPoints,
    passed: passed,
    currentQuestionIndex: currentQuestionIndex,
  );
}

/// Creates a sample QuizQuestion database row
QuizQuestion createQuizQuestionRow({
  String quizId = 'quiz-1',
  int questionId = 1,
  int orderIndex = 0,
  List<String> shuffledAnswerIds = const ['a1', 'a2', 'a3', 'a4'],
  String? selectedAnswerId,
  bool? wasCorrect,
  int points = 1,
  DateTime? answeredAt,
}) {
  return QuizQuestion(
    quizId: quizId,
    questionId: questionId,
    orderIndex: orderIndex,
    shuffledAnswerIdsJson: jsonEncode(shuffledAnswerIds),
    selectedAnswerId: selectedAnswerId,
    wasCorrect: wasCorrect,
    points: points,
    answeredAt: answeredAt,
  );
}

/// Creates a sample Question database row
Question createQuestionRow({
  int id = 1,
  String categoryId = 'basisfragen',
  String questionText = 'Sample question?',
  int points = 1,
  bool hasImages = false,
  List<String> imageRefs = const [],
  List<Map<String, dynamic>>? answers,
}) {
  final defaultAnswers = [
    {'id': 'a1', 'text': 'Correct answer', 'is_correct': true},
    {'id': 'a2', 'text': 'Wrong answer 1', 'is_correct': false},
    {'id': 'a3', 'text': 'Wrong answer 2', 'is_correct': false},
    {'id': 'a4', 'text': 'Wrong answer 3', 'is_correct': false},
  ];

  return Question(
    id: id,
    categoryId: categoryId,
    questionText: questionText,
    points: points,
    hasImages: hasImages,
    imageRefsJson: jsonEncode(imageRefs),
    answersJson: jsonEncode(answers ?? defaultAnswers),
  );
}

/// Creates a list of QuizQuestion rows for testing
List<QuizQuestion> createQuizQuestionRows({
  String quizId = 'quiz-1',
  int count = 30,
  int answeredCount = 0,
  int correctCount = 0,
}) {
  return List.generate(count, (index) {
    final isAnswered = index < answeredCount;
    final isCorrect = isAnswered && index < correctCount;

    return createQuizQuestionRow(
      quizId: quizId,
      questionId: index + 1,
      orderIndex: index,
      selectedAnswerId: isAnswered ? 'a1' : null,
      wasCorrect: isAnswered ? isCorrect : null,
      answeredAt: isAnswered ? DateTime.now() : null,
    );
  });
}
