import 'dart:convert';

import '../../../../core/db/app_database.dart' as db;
import '../../domain/entities/quiz.dart';
import '../../domain/entities/quiz_question_answer.dart';
import '../../domain/entities/quiz_result.dart';

class QuizMapper {
  Quiz fromDbRows(db.Quizze quizRow, List<db.QuizQuestion> questionRows) {
    final questions = questionRows.map(_questionFromDbRow).toList();
    questions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return Quiz(
      id: quizRow.id,
      type: _parseQuizType(quizRow.quizType),
      examSheetIndex: quizRow.examSheetIndex,
      startedAt: quizRow.startedAt,
      endedAt: quizRow.endedAt,
      status: _parseQuizStatus(quizRow.status),
      questions: questions,
      currentQuestionIndex: quizRow.currentQuestionIndex,
    );
  }

  QuizQuestionAnswer _questionFromDbRow(db.QuizQuestion row) {
    final shuffledAnswerIds =
        (jsonDecode(row.shuffledAnswerIdsJson) as List<dynamic>)
            .map((e) => e as String)
            .toList();

    return QuizQuestionAnswer(
      questionId: row.questionId,
      orderIndex: row.orderIndex,
      shuffledAnswerIds: shuffledAnswerIds,
      selectedAnswerId: row.selectedAnswerId,
      wasCorrect: row.wasCorrect,
      points: row.points,
      answeredAt: row.answeredAt,
    );
  }

  QuizType _parseQuizType(String type) {
    switch (type) {
      case 'motor':
        return QuizType.motor;
      case 'sailing_only':
        return QuizType.sailingOnly;
      case 'combined':
        return QuizType.combined;
      case 'custom':
        return QuizType.custom;
      default:
        return QuizType.custom;
    }
  }

  String quizTypeToString(QuizType type) {
    switch (type) {
      case QuizType.motor:
        return 'motor';
      case QuizType.sailingOnly:
        return 'sailing_only';
      case QuizType.combined:
        return 'combined';
      case QuizType.custom:
        return 'custom';
    }
  }

  QuizStatus _parseQuizStatus(String status) {
    switch (status) {
      case 'in_progress':
        return QuizStatus.inProgress;
      case 'completed':
        return QuizStatus.completed;
      case 'abandoned':
        return QuizStatus.abandoned;
      default:
        return QuizStatus.inProgress;
    }
  }

  String quizStatusToString(QuizStatus status) {
    switch (status) {
      case QuizStatus.inProgress:
        return 'in_progress';
      case QuizStatus.completed:
        return 'completed';
      case QuizStatus.abandoned:
        return 'abandoned';
    }
  }

  QuizResult createResult(Quiz quiz) {
    final duration = quiz.endedAt != null
        ? quiz.endedAt!.difference(quiz.startedAt)
        : Duration.zero;

    // German boating license requires 90% to pass
    final passed = quiz.earnedPoints >= (quiz.totalPoints * 0.9).ceil();

    return QuizResult(
      totalQuestions: quiz.totalQuestions,
      correctAnswers: quiz.correctCount,
      totalPoints: quiz.totalPoints,
      earnedPoints: quiz.earnedPoints,
      duration: duration,
      passed: passed,
    );
  }
}
