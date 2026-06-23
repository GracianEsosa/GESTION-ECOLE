import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/inscription_service.dart';

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final inscriptionServiceProvider = Provider<InscriptionService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return InscriptionService(db);
});

////////////////////////////////////////////////////
/// LISTE DES INSCRIPTIONS
////////////////////////////////////////////////////

final inscriptionsListProvider = FutureProvider<List<EleveInscription>>((
  ref,
) async {
  final service = ref.watch(inscriptionServiceProvider);

  return service.getInscriptions();
});

////////////////////////////////////////////////////
/// INSCRIPTIONS NON SYNCHRONISÉES
////////////////////////////////////////////////////

final unsyncedInscriptionsProvider = FutureProvider<List<EleveInscription>>((
  ref,
) async {
  final service = ref.watch(inscriptionServiceProvider);

  return service.getUnsyncedInscriptions();
});

////////////////////////////////////////////////////
/// RECHERCHE
////////////////////////////////////////////////////

final searchInscriptionsProvider =
    FutureProvider.family<List<EleveInscription>, String>((ref, motCle) async {
      final service = ref.watch(inscriptionServiceProvider);

      return service.rechercherInscriptions(motCle);
    });

////////////////////////////////////////////////////
/// RAFRAÎCHISSEMENT
////////////////////////////////////////////////////

final refreshOptionsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(inscriptionsListProvider);
  };
});
