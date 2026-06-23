import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/paiement_service.dart';

final paiementServiceProvider = Provider<PaiementService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaiementService(db);
});

final paiementsListProvider = FutureProvider<List<PaiementInscription>>((
  ref,
) async {
  final service = ref.watch(paiementServiceProvider);
  return service.getPaiements();
});

final unsyncedPaiementsProvider = FutureProvider<List<PaiementInscription>>((
  ref,
) async {
  final service = ref.watch(paiementServiceProvider);
  return service.getUnsyncedPaiements();
});

final paiementsByInscriptionProvider =
    FutureProvider.family<List<PaiementInscription>, String>((
      ref,
      idInscriptionUuid,
    ) async {
      final service = ref.watch(paiementServiceProvider);
      return service.rechercherPaiementsParInscription(idInscriptionUuid);
    });

final refreshPaiementsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(paiementsListProvider);
    ref.invalidate(unsyncedPaiementsProvider);
  };
});

final addPaiementProvider =
    FutureProvider.family<void, PaiementInscriptionsCompanion>((
      ref,
      data,
    ) async {
      final service = ref.watch(paiementServiceProvider);
      await service.ajouterPaiement(data);
      ref.invalidate(paiementsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);
    });

final updatePaiementProvider = FutureProvider.family<void, PaiementInscription>(
  (ref, paiement) async {
    final service = ref.watch(paiementServiceProvider);
    await service.modifierPaiement(paiement);
    ref.invalidate(paiementsListProvider);
    ref.invalidate(unsyncedPaiementsProvider);
  },
);

final deletePaiementProvider = FutureProvider.family<void, int>((
  ref,
  idPaiement,
) async {
  final service = ref.watch(paiementServiceProvider);
  await service.supprimerPaiement(idPaiement);
  ref.invalidate(paiementsListProvider);
  ref.invalidate(unsyncedPaiementsProvider);
});

final markPaiementSyncedProvider = FutureProvider.family<void, int>((
  ref,
  idPaiement,
) async {
  final service = ref.watch(paiementServiceProvider);
  await service.markAsSynced(idPaiement);
  ref.invalidate(paiementsListProvider);
  ref.invalidate(unsyncedPaiementsProvider);
});

final upsertPaiementFromServerProvider =
    FutureProvider.family<
      void,
      ({
        String uuid,
        String idInscriptionUuid,
        double montantPaye,
        DateTime datePaiement,
        String modePaiement,
        String motifPaiement,
        DateTime updatedAt,
      })
    >((ref, data) async {
      final service = ref.watch(paiementServiceProvider);
      await service.insertOrUpdateFromServer(
        uuid: data.uuid,
        idInscriptionUuid: data.idInscriptionUuid,
        montantPaye: data.montantPaye,
        datePaiement: data.datePaiement,
        modePaiement: data.modePaiement,
        motifPaiement: data.motifPaiement,
        updatedAt: data.updatedAt,
      );
      ref.invalidate(paiementsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);
    });
