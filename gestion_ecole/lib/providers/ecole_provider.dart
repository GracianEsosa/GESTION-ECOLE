import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/database_provider.dart';
import '../services/ecole_service.dart';

final ecoleServiceProvider = Provider<EcoleService>((ref) {
  return EcoleService(ref.watch(appDatabaseProvider));
});

final ecoleProvider = FutureProvider<EcoleInfo?>((ref) {
  return ref.watch(ecoleServiceProvider).getEcole();
});
