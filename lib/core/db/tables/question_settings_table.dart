import 'package:drift/drift.dart';

class QuestionSettings extends Table {
  TextColumn get key => text()();
  IntColumn get value => integer()();

  @override
  Set<Column> get primaryKey => {key};
}
