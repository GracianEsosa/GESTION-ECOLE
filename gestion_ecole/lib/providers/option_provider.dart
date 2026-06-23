import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import '../services/option_service.dart';
import '../database/app_database.dart';

////////////////////////////////////////////////////////
/// OPTION SERVICE
////////////////////////////////////////////////////////

final optionServiceProvider = Provider<OptionService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return OptionService(db);
});

////////////////////////////////////////////////////////
/// LISTE OPTIONS
////////////////////////////////////////////////////////

final optionsListProvider = FutureProvider<List<ScolaireOption>>((ref) async {
  final service = ref.watch(optionServiceProvider);
  return service.getOptions();
});

////////////////////////////////////////////////////////
/// REFRESH
////////////////////////////////////////////////////////

final refreshOptionsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(optionsListProvider);
  };
});
