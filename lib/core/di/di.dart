import 'package:get_it/get_it.dart';

import 'register_core.dart';
import 'register_features.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await registerCore(getIt);
  registerFeatures(getIt);
}