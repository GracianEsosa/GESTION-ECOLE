import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class PaiementService {
  final AppDatabase db;

  final Uuid _uuid = const Uuid();

  PaiementService(this.db);

  ////////////////////////////////////////////////////
  /// AJOUTER (avec génération d'UUID, isSynced=false, updatedAt)
  ////////////////////////////////////////////////////

  Future<int> ajouterPaiement(PaiementInscriptionsCompanion data) async {
    return await db
        .into(db.paiementInscriptions)
        .insert(
          data.copyWith(
            uuid: Value(_uuid.v4()),
            isSynced: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  ////////////////////////////////////////////////////
  /// LISTER (tous, ou filtrer si besoin)
  ////////////////////////////////////////////////////

  Future<List<PaiementInscription>> getPaiements() async {
    return await (db.select(
      db.paiementInscriptions,
    )..orderBy([(t) => OrderingTerm.desc(t.datePaiement)])).get();
  }

  ////////////////////////////////////////////////////
  /// RECHERCHE (optionnel, par inscription ou motif)
  ////////////////////////////////////////////////////

  Future<List<PaiementInscription>> rechercherPaiementsParInscription(
    String idInscriptionUuid,
  ) async {
    return await (db.select(
      db.paiementInscriptions,
    )..where((t) => t.idInscriptionUuid.equals(idInscriptionUuid))).get();
  }

  ////////////////////////////////////////////////////
  /// MODIFIER (mise à jour avec isSynced=false, updatedAt)
  ////////////////////////////////////////////////////

  Future<bool> modifierPaiement(PaiementInscription data) async {
    return await db
        .update(db.paiementInscriptions)
        .replace(data.copyWith(isSynced: false, updatedAt: DateTime.now()));
  }

  ////////////////////////////////////////////////////
  /// SUPPRESSION PHYSIQUE
  ////////////////////////////////////////////////////

  Future<int> supprimerPaiement(int idPaiement) async {
    return await (db.delete(
      db.paiementInscriptions,
    )..where((t) => t.idPaiement.equals(idPaiement))).go();
  }

  ////////////////////////////////////////////////////
  /// NON SYNCHRONISÉS
  ////////////////////////////////////////////////////

  Future<List<PaiementInscription>> getUnsyncedPaiements() async {
    return await (db.select(
      db.paiementInscriptions,
    )..where((t) => t.isSynced.equals(false))).get();
  }

  ////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISÉ
  ////////////////////////////////////////////////////

  Future<void> markAsSynced(int idPaiement) async {
    await (db.update(db.paiementInscriptions)
          ..where((t) => t.idPaiement.equals(idPaiement)))
        .write(const PaiementInscriptionsCompanion(isSynced: Value(true)));
  }

  ////////////////////////////////////////////////////
  /// INSERT / UPDATE DEPUIS LE SERVEUR
  ////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String idInscriptionUuid,
    required double montantPaye,
    required DateTime datePaiement,
    required String modePaiement,
    required String motifPaiement,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.paiementInscriptions,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.paiementInscriptions)
          .insert(
            PaiementInscriptionsCompanion.insert(
              uuid: uuid,
              idInscriptionUuid: idInscriptionUuid,
              montantPaye: montantPaye,
              datePaiement: Value(datePaiement),
              modePaiement: modePaiement,
              motifPaiement: motifPaiement,
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await (db.update(
        db.paiementInscriptions,
      )..where((t) => t.idPaiement.equals(existing.idPaiement))).write(
        PaiementInscriptionsCompanion(
          idInscriptionUuid: Value(idInscriptionUuid),
          montantPaye: Value(montantPaye),
          datePaiement: Value(datePaiement),
          modePaiement: Value(modePaiement),
          motifPaiement: Value(motifPaiement),
          updatedAt: Value(updatedAt),
          isSynced: const Value(true),
        ),
      );
    }
  }
}
