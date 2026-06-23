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

final syncServiceProvider = Provider((ref) {
  final db = ref.watch(appDatabaseProvider);

  return SyncService(db);
});

final unsyncedDataProvider = FutureProvider<SyncData>((ref) async {
  final service = ref.watch(syncServiceProvider);
  return await service.getUnsyncedData();
});

final syncStatusProvider = StateProvider<bool>((ref) => false);

final syncToServerProvider = FutureProvider<bool>((ref) async {
  try {
    ref.read(syncStatusProvider.notifier).state = true;

    final service = ref.read(syncServiceProvider);

    final success = await service.syncToServer();

    ref.read(syncStatusProvider.notifier).state = false;

    if (success) {
      ref.invalidate(anneesListProvider);
      ref.invalidate(optionsListProvider);
      ref.invalidate(classesListProvider);
      ref.invalidate(inscriptionsListProvider);
      ref.invalidate(paiementsListProvider);
      ref.invalidate(utilisateursListProvider);
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
