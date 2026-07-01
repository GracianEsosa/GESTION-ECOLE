// lib/providers/tarif_frais_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/tarif_frais_service.dart';

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final tarifFraisServiceProvider = Provider<TarifFraisService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TarifFraisService(db);
});

////////////////////////////////////////////////////
/// LISTE DES TARIFS DE FRAIS
////////////////////////////////////////////////////

final tarifsFraisListProvider = FutureProvider<List<TarifsFrai>>((ref) async {
  final service = ref.watch(tarifFraisServiceProvider);
  return service.getTarifs();
});

////////////////////////////////////////////////////
/// TARIFS DE FRAIS NON SYNCHRONISÉS
////////////////////////////////////////////////////

final unsyncedTarifsFraisProvider = FutureProvider<List<TarifsFrai>>((
  ref,
) async {
  final service = ref.watch(tarifFraisServiceProvider);
  return service.getUnsyncedTarifs();
});

////////////////////////////////////////////////////
/// RECHERCHE
////////////////////////////////////////////////////

final searchTarifsFraisProvider =
    FutureProvider.family<List<TarifsFrai>, String>((ref, motCle) async {
      final service = ref.watch(tarifFraisServiceProvider);
      return service.rechercherTarifs(motCle);
    });

////////////////////////////////////////////////////
/// TARIFS PAR ANNÉE
////////////////////////////////////////////////////

final tarifsFraisByAnneeProvider =
    FutureProvider.family<List<TarifsFrai>, String>((ref, anneeUuid) async {
      final service = ref.watch(tarifFraisServiceProvider);
      return service.getTarifsByAnnee(anneeUuid);
    });

////////////////////////////////////////////////////
/// TARIFS PAR CLASSE
////////////////////////////////////////////////////

final tarifsFraisByClasseProvider =
    FutureProvider.family<List<TarifsFrai>, (String, String)>((
      ref,
      args,
    ) async {
      final (anneeUuid, classeUuid) = args;
      final service = ref.watch(tarifFraisServiceProvider);
      return service.getTarifsByClasse(anneeUuid, classeUuid);
    });

////////////////////////////////////////////////////
/// RAFRAÎCHIR
////////////////////////////////////////////////////

final refreshTarifsFraisProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(tarifsFraisListProvider);
  };
});
