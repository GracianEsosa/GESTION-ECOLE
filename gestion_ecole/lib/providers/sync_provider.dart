import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../services/sync_service.dart';
import 'database_provider.dart';
import 'annee_provider.dart';
import 'classe_provider.dart';
import 'inscription_provider.dart';
import 'option_provider.dart';
import 'paiement_provider.dart';
import 'utilisateur_provider.dart';

// 🆕 Nouveaux providers pour les frais scolaires
import 'type_frais_provider.dart';
import 'tarif_frais_provider.dart';
// import 'facture_provider.dart';  // ❌ Supprimé (table Factures supprimée)

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final syncServiceProvider = Provider<SyncService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncService(db);
});

////////////////////////////////////////////////////
/// DONNÉES NON SYNCHRONISÉES
////////////////////////////////////////////////////

final unsyncedDataProvider = FutureProvider<SyncData>((ref) async {
  final service = ref.watch(syncServiceProvider);
  return await service.getUnsyncedData();
});

////////////////////////////////////////////////////
/// ÉTAT DE SYNCHRONISATION
////////////////////////////////////////////////////

final syncStatusProvider = StateProvider<bool>((ref) => false);

////////////////////////////////////////////////////
/// SYNCHRONISATION VERS LE SERVEUR
////////////////////////////////////////////////////

final syncToServerProvider = FutureProvider<bool>((ref) async {
  try {
    ref.read(syncStatusProvider.notifier).state = true;

    final service = ref.read(syncServiceProvider);

    final success = await service.syncToServer();

    ref.read(syncStatusProvider.notifier).state = false;

    if (success) {
      // Invalider les listes existantes
      ref.invalidate(anneesListProvider);
      ref.invalidate(optionsListProvider);
      ref.invalidate(classesListProvider);
      ref.invalidate(inscriptionsListProvider);
      ref.invalidate(paiementsListProvider);
      ref.invalidate(utilisateursListProvider);

      // 🆕 Invalider les nouvelles listes (sans factures)
      ref.invalidate(typesFraisListProvider);
      ref.invalidate(tarifsFraisListProvider);
      // ref.invalidate(facturesListProvider);  // ❌ Supprimé

      ref.invalidate(unsyncedDataProvider);
    }

    return success;
  } catch (e, s) {
    print("ERREUR SYNC = $e");
    print(s);

    ref.read(syncStatusProvider.notifier).state = false;

    return false;
  }
});
