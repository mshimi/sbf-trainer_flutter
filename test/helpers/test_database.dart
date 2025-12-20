import 'package:drift/native.dart';
import 'package:sbf_trainer/core/db/app_database.dart';

/// Creates an in-memory database for testing
AppDatabase createTestDatabase() {
  return AppDatabase.forTesting(NativeDatabase.memory());
}
