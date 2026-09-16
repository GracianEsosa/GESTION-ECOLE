// lib/services/paiement_service.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class PaiementService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  PaiementService(this.db);

  ////////////////////////////////////////////////////
  /// AJOUTER (avec paramètres nommés)
  ////////////////////////////////////////////////////

  Future<int> ajouterPaiement({
    required String idInscriptionUuid,
    required String idTarifFraisUuid, // 🔥 remplace idFactureUuid
    required double montantPaye,
    required DateTime datePaiement,
    required String modePaiement,
    required String motifPaiement,
  }) async {
    return await db
        .into(db.paiementInscriptions)
        .insert(
          PaiementInscriptionsCompanion(
            uuid: Value(_uuid.v4()),
            idInscriptionUuid: Value(idInscriptionUuid),
            idTarifFraisUuid: Value(idTarifFraisUuid), // 🔥 nouveau champ
            montantPaye: Value(montantPaye),
            datePaiement: Value(datePaiement),
            modePaiement: Value(modePaiement),
            motifPaiement: Value(motifPaiement),
            isSynced: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  ////////////////////////////////////////////////////
  /// LISTER
  ////////////////////////////////////////////////////

  Future<List<PaiementInscription>> getPaiements() async {
    return await (db.select(
      db.paiementInscriptions,
    )..orderBy([(t) => OrderingTerm.desc(t.datePaiement)])).get();
  }

  ////////////////////////////////////////////////////
  /// FLUX REACTIF (STREAM)
  ////////////////////////////////////////////////////

  Stream<List<PaiementInscription>> watchPaiements() {
    return (db.select(
      db.paiementInscriptions,
    )..orderBy([(t) => OrderingTerm.desc(t.datePaiement)])).watch();
  }

  ////////////////////////////////////////////////////
  /// RECHERCHE par inscription
  ////////////////////////////////////////////////////

  Future<List<PaiementInscription>> rechercherPaiementsParInscription(
    String idInscriptionUuid,
  ) async {
    return await (db.select(
      db.paiementInscriptions,
    )..where((t) => t.idInscriptionUuid.equals(idInscriptionUuid))).get();
  }

  Stream<List<PaiementInscription>> watchPaiementsParInscription(
    String idInscriptionUuid,
  ) {
    return (db.select(
      db.paiementInscriptions,
    )..where((t) => t.idInscriptionUuid.equals(idInscriptionUuid))).watch();
  }

  // 🔥 Suppression de rechercherPaiementsParFacture (car plus de factures)

  ////////////////////////////////////////////////////
  /// MODIFIER (avec PaiementInscription)
  ////////////////////////////////////////////////////

  Future<bool> modifierPaiement(PaiementInscription data) async {
    return await db
        .update(db.paiementInscriptions)
        .replace(data.copyWith(isSynced: false, updatedAt: DateTime.now()));
  }

  ////////////////////////////////////////////////////
  /// SUPPRIMER
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
    required String idTarifFraisUuid, // 🔥 remplace idFactureUuid
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
              idTarifFraisUuid: idTarifFraisUuid, // 🔥 nouveau
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
          idTarifFraisUuid: Value(idTarifFraisUuid), // 🔥 nouveau
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
