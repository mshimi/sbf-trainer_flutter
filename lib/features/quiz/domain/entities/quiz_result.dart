import 'package:equatable/equatable.dart';

import 'quiz.dart';

/// Result breakdown by category
class CategoryResult extends Equatable {
  final String categoryId;
  final String categoryName;
  final int totalQuestions;
  final int correctAnswers;
  final int requiredCorrect;
  final bool passed;

  const CategoryResult({
    required this.categoryId,
    required this.categoryName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.requiredCorrect,
    required this.passed,
  });

  int get errors => totalQuestions - correctAnswers;
  int get maxErrors => totalQuestions - requiredCorrect;

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        totalQuestions,
        correctAnswers,
        requiredCorrect,
        passed,
      ];
}

class QuizResult extends Equatable {
  final QuizType quizType;
  final int totalQuestions;
  final int correctAnswers;
  final int totalPoints;
  final int earnedPoints;
  final Duration duration;
  final bool passed;
  final List<CategoryResult> categoryResults;

  const QuizResult({
    required this.quizType,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalPoints,
    required this.earnedPoints,
    required this.duration,
    required this.passed,
    this.categoryResults = const [],
  });

  double get percentage =>
      totalPoints > 0 ? earnedPoints / totalPoints * 100 : 0;

  double get accuracy =>
      totalQuestions > 0 ? correctAnswers / totalQuestions * 100 : 0;

  /// Returns the failing categories (if any)
  List<CategoryResult> get failedCategories =>
      categoryResults.where((c) => !c.passed).toList();

  @override
  List<Object?> get props => [
        quizType,
        totalQuestions,
        correctAnswers,
        totalPoints,
        earnedPoints,
        duration,
        passed,
        categoryResults,
      ];
}

/// Official pass rules for SBF Binnen exams
class ExamPassRules {
  ExamPassRules._();

  /// Motor exam (30 questions):
  /// - Basisteil (7 questions from basisfragen): need 5+ correct (max 2 errors)
  /// - Spezifisch Binnen (23 questions): need 18+ correct (max 5 errors)
  static const int motorBasisRequired = 5;
  static const int motorBasisTotal = 7;
  static const int motorSpecificRequired = 18;
  static const int motorSpecificTotal = 23;

  /// Sailing only exam (25 questions):
  /// - Basisteil (7 questions): need 5+ correct
  /// - Spezifisch Segeln (18 questions): need 14+ correct (max 4 errors)
  static const int sailingBasisRequired = 5;
  static const int sailingBasisTotal = 7;
  static const int sailingSpecificRequired = 14;
  static const int sailingSpecificTotal = 18;

  /// Combined exam (37 questions = 30 motor + 7 sailing supplement):
  /// - Basisteil (7 questions): need 5+ correct
  /// - Spezifisch Binnen (23 questions): need 18+ correct
  /// - Ergänzung Segeln (7 questions): need 5+ correct
  static const int combinedSailingSupplementRequired = 5;
  static const int combinedSailingSupplementTotal = 7;

  /// Custom quiz: use simple 70% threshold
  static const double customPassPercentage = 0.7;
}
