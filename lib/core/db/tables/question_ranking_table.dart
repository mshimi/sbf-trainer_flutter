import 'package:drift/drift.dart';

import 'questions_table.dart';

class QuestionRankings extends Table {
  IntColumn get questionId => integer().references(Questions, #id)();
  IntColumn get timesCorrect => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {questionId};
}
