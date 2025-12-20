import 'package:sbf_trainer/features/quiz/domain/entities/quiz.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz_question_answer.dart';
import 'package:sbf_trainer/features/quiz/domain/entities/quiz_result.dart';

/// Creates a sample QuizQuestionAnswer with customizable properties
QuizQuestionAnswer createQuizQuestionAnswer({
  int questionId = 1,
  int orderIndex = 0,
  List<String> shuffledAnswerIds = const ['a1', 'a2', 'a3', 'a4'],
  String? selectedAnswerId,
  bool? wasCorrect,
  int points = 1,
  DateTime? answeredAt,
}) {
  return QuizQuestionAnswer(
    questionId: questionId,
    orderIndex: orderIndex,
    shuffledAnswerIds: shuffledAnswerIds,
    selectedAnswerId: selectedAnswerId,
    wasCorrect: wasCorrect,
    points: points,
    answeredAt: answeredAt,
  );
}

/// Creates a sample Quiz with customizable properties
Quiz createQuiz({
  String id = 'quiz-1',
  QuizType type = QuizType.motor,
  int? examSheetIndex,
  DateTime? startedAt,
  DateTime? endedAt,
  QuizStatus status = QuizStatus.inProgress,
  List<QuizQuestionAnswer>? questions,
  int currentQuestionIndex = 0,
}) {
  return Quiz(
    id: id,
    type: type,
    examSheetIndex: examSheetIndex,
    startedAt: startedAt ?? DateTime.now(),
    endedAt: endedAt,
    status: status,
    questions: questions ?? [],
    currentQuestionIndex: currentQuestionIndex,
  );
}

/// Creates a sample CategoryResult with customizable properties
CategoryResult createCategoryResult({
  String categoryId = 'basisfragen',
  String categoryName = 'Basisfragen',
  int totalQuestions = 7,
  int correctAnswers = 5,
  int requiredCorrect = 5,
  bool passed = true,
}) {
  return CategoryResult(
    categoryId: categoryId,
    categoryName: categoryName,
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    requiredCorrect: requiredCorrect,
    passed: passed,
  );
}

/// Creates a sample QuizResult with customizable properties
QuizResult createQuizResult({
  QuizType quizType = QuizType.motor,
  int totalQuestions = 30,
  int correctAnswers = 25,
  int totalPoints = 30,
  int earnedPoints = 25,
  Duration duration = const Duration(minutes: 15),
  bool passed = true,
  List<CategoryResult>? categoryResults,
}) {
  return QuizResult(
    quizType: quizType,
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    totalPoints: totalPoints,
    earnedPoints: earnedPoints,
    duration: duration,
    passed: passed,
    categoryResults: categoryResults ?? [],
  );
}

/// Creates a list of QuizQuestionAnswers for testing
List<QuizQuestionAnswer> createQuizQuestionsList({
  int count = 30,
  int answeredCount = 0,
  int correctCount = 0,
}) {
  return List.generate(count, (index) {
    final isAnswered = index < answeredCount;
    final isCorrect = isAnswered && index < correctCount;

    return createQuizQuestionAnswer(
      questionId: index + 1,
      orderIndex: index,
      selectedAnswerId: isAnswered ? 'a1' : null,
      wasCorrect: isAnswered ? isCorrect : null,
      answeredAt: isAnswered ? DateTime.now() : null,
    );
  });
}

/// Creates a Quiz with specified answered/correct counts for testing computed properties
Quiz createQuizWithAnswers({
  String id = 'quiz-1',
  QuizType type = QuizType.motor,
  int totalQuestions = 30,
  int answeredCount = 0,
  int correctCount = 0,
  QuizStatus status = QuizStatus.inProgress,
}) {
  return createQuiz(
    id: id,
    type: type,
    status: status,
    questions: createQuizQuestionsList(
      count: totalQuestions,
      answeredCount: answeredCount,
      correctCount: correctCount,
    ),
  );
}

/// Creates a completed Quiz for testing
Quiz createCompletedQuiz({
  String id = 'quiz-1',
  QuizType type = QuizType.motor,
  int totalQuestions = 30,
  int correctCount = 25,
}) {
  return createQuizWithAnswers(
    id: id,
    type: type,
    totalQuestions: totalQuestions,
    answeredCount: totalQuestions,
    correctCount: correctCount,
    status: QuizStatus.completed,
  );
}

/// Creates motor exam category results for testing pass/fail logic
List<CategoryResult> createMotorExamCategoryResults({
  int basisCorrect = 5,
  int specificCorrect = 18,
}) {
  return [
    createCategoryResult(
      categoryId: 'basisfragen',
      categoryName: 'Basisfragen',
      totalQuestions: 7,
      correctAnswers: basisCorrect,
      requiredCorrect: 5,
      passed: basisCorrect >= 5,
    ),
    createCategoryResult(
      categoryId: 'spezifischbinnen',
      categoryName: 'Spezifisch Binnen',
      totalQuestions: 23,
      correctAnswers: specificCorrect,
      requiredCorrect: 18,
      passed: specificCorrect >= 18,
    ),
  ];
}

/// Creates sailing exam category results for testing pass/fail logic
List<CategoryResult> createSailingExamCategoryResults({
  int basisCorrect = 5,
  int specificCorrect = 14,
}) {
  return [
    createCategoryResult(
      categoryId: 'basisfragen',
      categoryName: 'Basisfragen',
      totalQuestions: 7,
      correctAnswers: basisCorrect,
      requiredCorrect: 5,
      passed: basisCorrect >= 5,
    ),
    createCategoryResult(
      categoryId: 'spezifischsegeln',
      categoryName: 'Spezifisch Segeln',
      totalQuestions: 18,
      correctAnswers: specificCorrect,
      requiredCorrect: 14,
      passed: specificCorrect >= 14,
    ),
  ];
}
