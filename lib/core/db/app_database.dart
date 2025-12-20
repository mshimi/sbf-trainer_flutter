import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/question_ranking_table.dart';
import 'tables/question_settings_table.dart';
import 'tables/questions_table.dart';
import 'tables/quiz_questions_table.dart';
import 'tables/quizzes_table.dart';

part 'app_database.g.dart';

const String kDbFileName = 'sbf_trainer.sqlite';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, kDbFileName));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [
  Questions,
  QuestionRankings,
  QuestionSettings,
  Quizzes,
  QuizQuestions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with custom executor (e.g., in-memory database)
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(questionSettings);
          }
          if (from < 3) {
            // Re-create questions and rankings tables to fix answer id type
            await m.deleteTable('question_rankings');
            await m.deleteTable('questions');
            await m.createTable(questions);
            await m.createTable(questionRankings);
          }
          if (from < 4) {
            await m.createTable(quizzes);
            await m.createTable(quizQuestions);
          }
        },
      );

  /// Clears all data from all tables
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(quizQuestions).go();
      await delete(quizzes).go();
      await delete(questionRankings).go();
      await delete(questions).go();
      await delete(questionSettings).go();
    });
  }

  /// Resets only quiz progress (rankings and quizzes) keeping questions
  Future<void> resetProgress() async {
    await transaction(() async {
      await delete(quizQuestions).go();
      await delete(quizzes).go();
      // Reset all rankings to 0
      await update(questionRankings).write(
        const QuestionRankingsCompanion(timesCorrect: Value(0)),
      );
    });
  }
}
