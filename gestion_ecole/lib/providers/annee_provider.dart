import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/annee_service.dart';

final anneeServiceProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);
  return AnneeService(db);
});

final anneesListProvider = FutureProvider<List<AnneeScolaire>>((ref) async {
  final service = ref.watch(anneeServiceProvider);
  return await service.getAnnees();
});

final refreshAnneesProvider = Provider((ref) {
  return () {
    ref.refresh(anneesListProvider);
  };
});
