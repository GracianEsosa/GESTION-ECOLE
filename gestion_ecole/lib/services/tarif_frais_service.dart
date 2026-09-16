import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class TarifFraisService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  TarifFraisService(this.db);

  //////////////////////////////////////////////////////
  /// AJOUTER
  //////////////////////////////////////////////////////

  // tarif_frais_service.dart

  Future<int> ajouterTarif(
    String idTypeFraisUuid,
    String idAnneeUuid,
    String idClasseUuid,
    double montant, {
    int trimestre = 1,
  }) async {
    return await db
        .into(db.tarifsFrais)
        .insert(
          TarifsFraisCompanion.insert(
            uuid: _uuid.v4(),
            idTypeFraisUuid: idTypeFraisUuid,
            idAnneeUuid: idAnneeUuid,
            idClasseUuid: Value(idClasseUuid),
            montant: montant,
            trimestre: Value(trimestre),
          ),
        );
  }

  /// Génère les tarifs pour toutes les périodes (trimestres 1-3 ou mois 1-10)
  Future<void> meublerTarifsPourTypeFrais({
    required String idTypeFraisUuid,
    required String idAnneeUuid,
    String? idClasseUuid,
    required double montant,
    required String periodicite,
  }) async {
    if (periodicite == 'trimestriel') {
      for (int t = 1; t <= 3; t++) {
        await ajouterTarif(
          idTypeFraisUuid,
          idAnneeUuid,
          idClasseUuid ?? '',
          montant,
          trimestre: t,
        );
      }
    } else if (periodicite == 'annuel' || periodicite == 'mensuel') {
      for (int m = 1; m <= 10; m++) {
        await ajouterTarif(
          idTypeFraisUuid,
          idAnneeUuid,
          idClasseUuid ?? '',
          montant,
          trimestre: m,
        );
      }
    } else {
      await ajouterTarif(
        idTypeFraisUuid,
        idAnneeUuid,
        idClasseUuid ?? '',
        montant,
        trimestre: 1,
      );
    }
  }

  //////////////////////////////////////////////////////
  /// LISTE
  //////////////////////////////////////////////////////

  Future<List<TarifsFrai>> getTarifs() async {
    return await (db.select(
      db.tarifsFrais,
    )..orderBy([(t) => OrderingTerm.asc(t.montant)])).get();
  }

  //////////////////////////////////////////////////////
  /// RECHERCHE
  //////////////////////////////////////////////////////

  Future<List<TarifsFrai>> rechercherTarifs(String motCle) async {
    return await (db.select(db.tarifsFrais)).get();
  }

  //////////////////////////////////////////////////////
  /// MODIFIER
  //////////////////////////////////////////////////////

  Future<bool> modifierTarif(
    int idTarif,
    String idTypeFraisUuid,
    String idAnneeUuid,
    String? idClasseUuid,
    double montant, {
    int trimestre = 1,
  }) async {
    final existing = await (db.select(
      db.tarifsFrais,
    )..where((tbl) => tbl.idTarif.equals(idTarif))).getSingleOrNull();

    if (existing == null) {
      return false;
    }

    return await db
        .update(db.tarifsFrais)
        .replace(
          existing.copyWith(
            idTypeFraisUuid: idTypeFraisUuid,
            idAnneeUuid: idAnneeUuid,
            idClasseUuid: Value(idClasseUuid),
            montant: montant,
            trimestre: trimestre,
            isSynced: false,
            updatedAt: DateTime.now(),
          ),
        );
  }

  //////////////////////////////////////////////////////
  /// SUPPRIMER
  //////////////////////////////////////////////////////

  Future<int> supprimerTarif(int idTarif) async {
    return await (db.delete(
      db.tarifsFrais,
    )..where((tbl) => tbl.idTarif.equals(idTarif))).go();
  }

  //////////////////////////////////////////////////////
  /// NON SYNCHRONISÉES
  //////////////////////////////////////////////////////

  Future<List<TarifsFrai>> getUnsyncedTarifs() async {
    return await (db.select(
      db.tarifsFrais,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  //////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISÉ
  //////////////////////////////////////////////////////

  Future<void> markAsSynced(int idTarif) async {
    await (db.update(db.tarifsFrais)
          ..where((tbl) => tbl.idTarif.equals(idTarif)))
        .write(TarifsFraisCompanion(isSynced: const Value(true)));
  }

  //////////////////////////////////////////////////////
  /// INSERTION DEPUIS SERVEUR
  //////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String idTypeFraisUuid,
    required String idAnneeUuid,
    String? idClasseUuid,
    required double montant,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.tarifsFrais,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.tarifsFrais)
          .insert(
            TarifsFraisCompanion.insert(
              uuid: uuid,
              idTypeFraisUuid: idTypeFraisUuid,
              idAnneeUuid: idAnneeUuid,
              idClasseUuid: Value(idClasseUuid),
              montant: montant,
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await db
          .update(db.tarifsFrais)
          .replace(
            existing.copyWith(
              idTypeFraisUuid: idTypeFraisUuid,
              idAnneeUuid: idAnneeUuid,
              idClasseUuid: Value(idClasseUuid),
              montant: montant,
              updatedAt: updatedAt,
              isSynced: true,
            ),
          );
    }
  }

  //////////////////////////////////////////////////////
  /// RECHERCHES SPÉCIFIQUES
  //////////////////////////////////////////////////////

  Future<List<TarifsFrai>> getTarifsByAnnee(String anneeUuid) async {
    return await (db.select(
      db.tarifsFrais,
    )..where((tbl) => tbl.idAnneeUuid.equals(anneeUuid))).get();
  }

  Future<List<TarifsFrai>> getTarifsByClasse(
    String anneeUuid,
    String classeUuid,
  ) async {
    return await (db.select(db.tarifsFrais)..where(
          (tbl) =>
              tbl.idAnneeUuid.equals(anneeUuid) &
              (tbl.idClasseUuid.equals(classeUuid) | tbl.idClasseUuid.isNull()),
        ))
        .get();
  }
}
