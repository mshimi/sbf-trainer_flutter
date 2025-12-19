import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../db/app_database.dart';

Future<void> registerCore(GetIt getIt) async {
  // Logger
  getIt.registerLazySingleton<Logger>(() => Logger());

  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

}
