// lib/providers/type_frais_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/type_frais_service.dart';

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final typeFraisServiceProvider = Provider<TypeFraisService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TypeFraisService(db);
});

////////////////////////////////////////////////////
/// LISTE DES TYPES DE FRAIS
////////////////////////////////////////////////////

final typesFraisListProvider = FutureProvider<List<TypesFrai>>((ref) async {
  final service = ref.watch(typeFraisServiceProvider);
  return service.getTypesFrais();
});

////////////////////////////////////////////////////
/// TYPES DE FRAIS NON SYNCHRONISÉS
////////////////////////////////////////////////////

final unsyncedTypesFraisProvider = FutureProvider<List<TypesFrai>>((ref) async {
  final service = ref.watch(typeFraisServiceProvider);
  return service.getUnsyncedTypesFrais();
});

////////////////////////////////////////////////////
/// RECHERCHE
////////////////////////////////////////////////////

final searchTypesFraisProvider = FutureProvider.family<List<TypesFrai>, String>(
  (ref, motCle) async {
    final service = ref.watch(typeFraisServiceProvider);
    return service.rechercherTypesFrais(motCle);
  },
);

////////////////////////////////////////////////////
/// RAFRAÎCHIR
////////////////////////////////////////////////////

final refreshTypesFraisProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(typesFraisListProvider);
  };
});
