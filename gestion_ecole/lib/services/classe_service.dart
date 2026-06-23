import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class ClasseService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  ClasseService(this.db);

  ////////////////////////////////////////////////////
  /// AJOUTER
  ////////////////////////////////////////////////////

  Future<int> ajouterClasse(
    String nomClasse,
    String? idOptionUuid,
    int effectifMax,
  ) async {
    return await db
        .into(db.classes)
        .insert(
          ClassesCompanion.insert(
            uuid: _uuid.v4(),
            nomClasse: nomClasse,
            idOptionUuid: Value(idOptionUuid), // ✅ FIX
            effectifMax: Value(effectifMax), // ✅ plus propre
          ),
        );
  }

  ////////////////////////////////////////////////////
  /// LISTE
  ////////////////////////////////////////////////////

  Future<List<ClassesData>> getClasses() async {
    return await (db.select(
      db.classes,
    )..orderBy([(t) => OrderingTerm.asc(t.nomClasse)])).get();
  }

  ////////////////////////////////////////////////////
  /// RECHERCHE
  ////////////////////////////////////////////////////

  Future<List<ClassesData>> rechercherClasses(String motCle) async {
    return await (db.select(
      db.classes,
    )..where((tbl) => tbl.nomClasse.like('%$motCle%'))).get();
  }

  ////////////////////////////////////////////////////
  /// MODIFIER
  ////////////////////////////////////////////////////

  Future<bool> modifierClasse(
    int idClasse,
    String nomClasse,
    String? idOptionUuid,
    int effectifMax,
  ) async {
    final existing = await (db.select(
      db.classes,
    )..where((tbl) => tbl.idClasse.equals(idClasse))).getSingleOrNull();

    if (existing == null) {
      return false;
    }

    final rowsUpdated =
        await (db.update(
          db.classes,
        )..where((tbl) => tbl.idClasse.equals(idClasse))).write(
          ClassesCompanion(
            nomClasse: Value(nomClasse),
            idOptionUuid: Value<String?>(idOptionUuid), // ✅ FIX IMPORTANT
            effectifMax: Value(effectifMax),
            isSynced: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );

    return rowsUpdated > 0;
  }

  ////////////////////////////////////////////////////
  /// SUPPRIMER
  ////////////////////////////////////////////////////

  Future<int> supprimerClasse(int id) async {
    return await (db.delete(
      db.classes,
    )..where((tbl) => tbl.idClasse.equals(id))).go();
  }

  ////////////////////////////////////////////////////
  /// NON SYNCHRONISÉES
  ////////////////////////////////////////////////////

  Future<List<ClassesData>> getUnsyncedClasses() async {
    return await (db.select(
      db.classes,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  ////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISÉ
  ////////////////////////////////////////////////////

  Future<void> markAsSynced(int idClasse) async {
    await (db.update(db.classes)..where((tbl) => tbl.idClasse.equals(idClasse)))
        .write(const ClassesCompanion(isSynced: Value(true)));
  }

  ////////////////////////////////////////////////////
  /// INSERT OU UPDATE SERVEUR
  ////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String nomClasse,
    String? idOptionUuid,
    required int effectifMax,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.classes,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.classes)
          .insert(
            ClassesCompanion.insert(
              uuid: uuid,
              nomClasse: nomClasse,
              idOptionUuid: Value(idOptionUuid),
              effectifMax: Value(effectifMax),
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await (db.update(
        db.classes,
      )..where((tbl) => tbl.idClasse.equals(existing.idClasse))).write(
        ClassesCompanion(
          nomClasse: Value(nomClasse),
          idOptionUuid: Value<String?>(idOptionUuid),
          effectifMax: Value(effectifMax),
          updatedAt: Value(updatedAt),
          isSynced: const Value(true),
        ),
      );
    }
  }
}
