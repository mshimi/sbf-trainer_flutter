import 'package:drift/drift.dart';

class Quizzes extends Table {
  TextColumn get id => text()(); // unique quiz ID
  TextColumn get quizType =>
      text()(); // 'motor', 'sailing_only', 'combined', 'custom'
  IntColumn get examSheetIndex =>
      integer().nullable()(); // exam sheet number (0-14), null for custom
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()(); // null = in progress
  TextColumn get status => text()
      .withDefault(const Constant('in_progress'))(); // 'in_progress', 'completed', 'abandoned'
  IntColumn get totalQuestions => integer()();
  IntColumn get correctAnswers => integer().withDefault(const Constant(0))();
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();
  IntColumn get earnedPoints => integer().withDefault(const Constant(0))();
  BoolColumn get passed => boolean().nullable()(); // null until completed
  IntColumn get currentQuestionIndex =>
      integer().withDefault(const Constant(0))(); // resume position

  @override
  Set<Column> get primaryKey => {id};
}
