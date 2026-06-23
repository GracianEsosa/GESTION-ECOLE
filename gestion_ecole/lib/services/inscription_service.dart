import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class InscriptionService {
  final AppDatabase db;

  final Uuid _uuid = const Uuid();

  InscriptionService(this.db);

  ////////////////////////////////////////////////////
  /// AJOUTER
  ////////////////////////////////////////////////////

  Future<int> ajouterInscription(EleveInscriptionsCompanion data) async {
    return await db
        .into(db.eleveInscriptions)
        .insert(
          data.copyWith(
            uuid: Value(_uuid.v4()),
            isSynced: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  ////////////////////////////////////////////////////
  /// LISTER
  ////////////////////////////////////////////////////

  Future<List<EleveInscription>> getInscriptions() async {
    return await (db.select(
      db.eleveInscriptions,
    )..orderBy([(t) => OrderingTerm.desc(t.dateInscription)])).get();
  }

  ////////////////////////////////////////////////////
  /// RECHERCHE
  ////////////////////////////////////////////////////

  Future<List<EleveInscription>> rechercherInscriptions(String motCle) async {
    return await (db.select(db.eleveInscriptions)..where(
          (tbl) =>
              tbl.nomEleve.like('%$motCle%') |
              tbl.prenomEleve.like('%$motCle%'),
        ))
        .get();
  }

  ////////////////////////////////////////////////////
  /// MODIFIER
  ////////////////////////////////////////////////////

  Future<bool> modifierInscription(EleveInscription data) async {
    return await db
        .update(db.eleveInscriptions)
        .replace(data.copyWith(isSynced: false, updatedAt: DateTime.now()));
  }

  ////////////////////////////////////////////////////
  /// SUPPRESSION PHYSIQUE
  ////////////////////////////////////////////////////

  Future<int> supprimerInscription(int idInscription) async {
    return await (db.delete(
      db.eleveInscriptions,
    )..where((tbl) => tbl.idInscription.equals(idInscription))).go();
  }

  ////////////////////////////////////////////////////
  /// NON SYNCHRONISÉES
  ////////////////////////////////////////////////////

  Future<List<EleveInscription>> getUnsyncedInscriptions() async {
    return await (db.select(
      db.eleveInscriptions,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  ////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISÉ
  ////////////////////////////////////////////////////

  Future<void> markAsSynced(int idInscription) async {
    await (db.update(db.eleveInscriptions)
          ..where((tbl) => tbl.idInscription.equals(idInscription)))
        .write(const EleveInscriptionsCompanion(isSynced: Value(true)));
  }

  ////////////////////////////////////////////////////
  /// INSERT / UPDATE DEPUIS LE SERVEUR
  ////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String nomEleve,
    required String prenomEleve,
    required DateTime dateNaissance,
    required String sexe,
    required String idAnneeUuid,
    required String idClasseUuid,
    required DateTime dateInscription,
    required String statutInscription,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.eleveInscriptions,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.eleveInscriptions)
          .insert(
            EleveInscriptionsCompanion.insert(
              uuid: uuid,
              nomEleve: nomEleve,
              prenomEleve: prenomEleve,
              dateNaissance: dateNaissance,
              sexe: sexe,
              idAnneeUuid: idAnneeUuid,
              idClasseUuid: idClasseUuid,
              dateInscription: Value(dateInscription),
              statutInscription: Value(statutInscription),
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await (db.update(db.eleveInscriptions)
            ..where((tbl) => tbl.idInscription.equals(existing.idInscription)))
          .write(
            EleveInscriptionsCompanion(
              nomEleve: Value(nomEleve),
              prenomEleve: Value(prenomEleve),
              dateNaissance: Value(dateNaissance),
              sexe: Value(sexe),
              idAnneeUuid: Value(idAnneeUuid),
              idClasseUuid: Value(idClasseUuid),
              dateInscription: Value(dateInscription),
              statutInscription: Value(statutInscription),
              updatedAt: Value(updatedAt),
              isSynced: const Value(true),
            ),
          );
    }
  }
}
