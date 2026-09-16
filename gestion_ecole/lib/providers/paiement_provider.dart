import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/paiement_service.dart';

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final paiementServiceProvider = Provider<PaiementService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PaiementService(db);
});

////////////////////////////////////////////////////
/// LISTE DES PAIEMENTS (FLUX RÉACTIF EN TEMPS RÉEL)
////////////////////////////////////////////////////

final paiementsListProvider = StreamProvider<List<PaiementInscription>>((
  ref,
) {
  final service = ref.watch(paiementServiceProvider);
  return service.watchPaiements();
});

////////////////////////////////////////////////////
/// PAIEMENTS NON SYNCHRONISÉS
////////////////////////////////////////////////////

final unsyncedPaiementsProvider = FutureProvider<List<PaiementInscription>>((
  ref,
) async {
  final service = ref.watch(paiementServiceProvider);
  return service.getUnsyncedPaiements();
});

////////////////////////////////////////////////////
/// PAIEMENTS PAR INSCRIPTION (FLUX RÉACTIF EN TEMPS RÉEL)
////////////////////////////////////////////////////

final paiementsByInscriptionProvider =
    StreamProvider.family<List<PaiementInscription>, String>((
      ref,
      idInscriptionUuid,
    ) {
      final service = ref.watch(paiementServiceProvider);
      return service.watchPaiementsParInscription(idInscriptionUuid);
    });

////////////////////////////////////////////////////
/// RAFRAÎCHIR
////////////////////////////////////////////////////

final refreshPaiementsProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(paiementsListProvider);
    ref.invalidate(unsyncedPaiementsProvider);
  };
});

////////////////////////////////////////////////////
/// AJOUTER UN PAIEMENT
////////////////////////////////////////////////////

final addPaiementProvider =
    FutureProvider.family<
      void,
      ({
        String idInscriptionUuid,
        String idTarifFraisUuid, // 🔥 remplace idFactureUuid
        double montantPaye,
        DateTime datePaiement,
        String modePaiement,
        String motifPaiement,
      })
    >((ref, data) async {
      final service = ref.watch(paiementServiceProvider);
      await service.ajouterPaiement(
        idInscriptionUuid: data.idInscriptionUuid,
        idTarifFraisUuid: data.idTarifFraisUuid,
        montantPaye: data.montantPaye,
        datePaiement: data.datePaiement,
        modePaiement: data.modePaiement,
        motifPaiement: data.motifPaiement,
      );
      ref.invalidate(paiementsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);
    });

////////////////////////////////////////////////////
/// MODIFIER UN PAIEMENT
////////////////////////////////////////////////////

final updatePaiementProvider = FutureProvider.family<void, PaiementInscription>(
  (ref, paiement) async {
    final service = ref.watch(paiementServiceProvider);
    await service.modifierPaiement(paiement);
    ref.invalidate(paiementsListProvider);
    ref.invalidate(unsyncedPaiementsProvider);
  },
);

////////////////////////////////////////////////////
/// SUPPRIMER UN PAIEMENT
////////////////////////////////////////////////////

final deletePaiementProvider = FutureProvider.family<void, int>((
  ref,
  idPaiement,
) async {
  final service = ref.watch(paiementServiceProvider);
  await service.supprimerPaiement(idPaiement);
  ref.invalidate(paiementsListProvider);
  ref.invalidate(unsyncedPaiementsProvider);
});

////////////////////////////////////////////////////
/// MARQUER UN PAIEMENT SYNCHRONISÉ
////////////////////////////////////////////////////

final markPaiementSyncedProvider = FutureProvider.family<void, int>((
  ref,
  idPaiement,
) async {
  final service = ref.watch(paiementServiceProvider);
  await service.markAsSynced(idPaiement);
  ref.invalidate(paiementsListProvider);
  ref.invalidate(unsyncedPaiementsProvider);
});

////////////////////////////////////////////////////
/// UPSERT DEPUIS LE SERVEUR
////////////////////////////////////////////////////

final upsertPaiementFromServerProvider =
    FutureProvider.family<
      void,
      ({
        String uuid,
        String idInscriptionUuid,
        String idTarifFraisUuid, // 🔥 remplace idFactureUuid
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
        idTarifFraisUuid: data.idTarifFraisUuid,
        montantPaye: data.montantPaye,
        datePaiement: data.datePaiement,
        modePaiement: data.modePaiement,
        motifPaiement: data.motifPaiement,
        updatedAt: data.updatedAt,
      );
      ref.invalidate(paiementsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);
    });
