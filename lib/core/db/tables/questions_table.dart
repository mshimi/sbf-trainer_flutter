import 'package:drift/drift.dart';

class Questions extends Table {
  IntColumn get id => integer()(); // question id from catalog
  TextColumn get categoryId => text()();
  TextColumn get questionText => text()();
  IntColumn get points => integer()();
  BoolColumn get hasImages => boolean().withDefault(const Constant(false))();
  TextColumn get imageRefsJson =>
      text().withDefault(const Constant('[]'))(); // list stored as JSON

  TextColumn get answersJson => text().withDefault(const Constant('[]'))(); //list of Answers as Json

  @override
  Set<Column> get primaryKey => {id};
}
