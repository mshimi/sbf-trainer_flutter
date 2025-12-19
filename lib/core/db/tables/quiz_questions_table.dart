import 'package:drift/drift.dart';

import 'questions_table.dart';
import 'quizzes_table.dart';

class QuizQuestions extends Table {
  TextColumn get quizId => text().references(Quizzes, #id)();
  IntColumn get questionId => integer().references(Questions, #id)();
  IntColumn get orderIndex => integer()(); // position in quiz (0-based)
  TextColumn get shuffledAnswerIdsJson =>
      text()(); // JSON array of shuffled answer IDs: ["a", "c", "b", "d"]
  TextColumn get selectedAnswerId =>
      text().nullable()(); // user's selected answer ID
  BoolColumn get wasCorrect => boolean().nullable()(); // null if not answered
  IntColumn get points => integer()(); // points for this question
  DateTimeColumn get answeredAt => dateTime().nullable()(); // when answered

  @override
  Set<Column> get primaryKey => {quizId, questionId};
}
