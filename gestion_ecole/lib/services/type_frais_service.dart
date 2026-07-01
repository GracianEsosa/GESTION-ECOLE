import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class TypeFraisService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  TypeFraisService(this.db);

  //////////////////////////////////////////////////////
  /// AJOUTER
  //////////////////////////////////////////////////////

  Future<int> ajouterTypeFrais(
    String code,
    String libelle,
    String? description,
    String periodicite,
  ) async {
    return await db
        .into(db.typesFrais)
        .insert(
          TypesFraisCompanion.insert(
            uuid: _uuid.v4(),
            code: code,
            libelle: libelle,
            description: Value(description),
            periodicite: Value(periodicite),
            actif: const Value(true),
          ),
        );
  }

  //////////////////////////////////////////////////////
  /// LISTE
  //////////////////////////////////////////////////////

  Future<List<TypesFrai>> getTypesFrais() async {
    return await (db.select(db.typesFrais)
          ..where((t) => t.actif.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.libelle)]))
        .get();
  }

  //////////////////////////////////////////////////////
  /// RECHERCHE
  //////////////////////////////////////////////////////

  Future<List<TypesFrai>> rechercherTypesFrais(String motCle) async {
    return await (db.select(db.typesFrais)..where(
          (tbl) =>
              tbl.actif.equals(true) &
              (tbl.code.like('%$motCle%') | tbl.libelle.like('%$motCle%')),
        ))
        .get();
  }

  //////////////////////////////////////////////////////
  /// MODIFIER
  //////////////////////////////////////////////////////

  Future<bool> modifierTypeFrais(
    int idTypeFrais,
    String code,
    String libelle,
    String? description,
    String periodicite,
    bool actif,
  ) async {
    final existing = await (db.select(
      db.typesFrais,
    )..where((tbl) => tbl.idTypeFrais.equals(idTypeFrais))).getSingleOrNull();

    if (existing == null) {
      return false;
    }

    return await db
        .update(db.typesFrais)
        .replace(
          existing.copyWith(
            code: code,
            libelle: libelle,
            description: Value(description),
            periodicite: periodicite,
            actif: actif,
            isSynced: false,
            updatedAt: DateTime.now(),
          ),
        );
  }

  //////////////////////////////////////////////////////
  /// SUPPRIMER (logique : désactiver)
  //////////////////////////////////////////////////////

  Future<bool> supprimerTypeFrais(int idTypeFrais) async {
    final existing = await (db.select(
      db.typesFrais,
    )..where((tbl) => tbl.idTypeFrais.equals(idTypeFrais))).getSingleOrNull();

    if (existing == null) {
      return false;
    }

    await db
        .update(db.typesFrais)
        .replace(
          existing.copyWith(
            actif: false,
            isSynced: false,
            updatedAt: DateTime.now(),
          ),
        );
    return true;
  }

  //////////////////////////////////////////////////////
  /// NON SYNCHRONISÉES
  //////////////////////////////////////////////////////

  Future<List<TypesFrai>> getUnsyncedTypesFrais() async {
    return await (db.select(
      db.typesFrais,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  //////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISÉ
  //////////////////////////////////////////////////////

  Future<void> markAsSynced(int idTypeFrais) async {
    await (db.update(db.typesFrais)
          ..where((tbl) => tbl.idTypeFrais.equals(idTypeFrais)))
        .write(TypesFraisCompanion(isSynced: const Value(true)));
  }

  //////////////////////////////////////////////////////
  /// INSERTION DEPUIS SERVEUR
  //////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String code,
    required String libelle,
    String? description,
    required String periodicite,
    required bool actif,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.typesFrais,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.typesFrais)
          .insert(
            TypesFraisCompanion.insert(
              uuid: uuid,
              code: code,
              libelle: libelle,
              description: Value(description),
              periodicite: Value(periodicite),
              actif: Value(actif),
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await db
          .update(db.typesFrais)
          .replace(
            existing.copyWith(
              code: code,
              libelle: libelle,
              description: Value(description),
              periodicite: periodicite,
              actif: actif,
              updatedAt: updatedAt,
              isSynced: true,
            ),
          );
    }
  }
}
