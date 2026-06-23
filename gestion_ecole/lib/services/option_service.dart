import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class OptionService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  OptionService(this.db);

  //////////////////////////////////////////////////////
  /// AJOUTER
  //////////////////////////////////////////////////////

  Future<int> ajouterOption(String nomOption, String? description) async {
    return await db
        .into(db.scolaireOptions)
        .insert(
          ScolaireOptionsCompanion.insert(
            uuid: _uuid.v4(),
            nomOption: nomOption,
            description: Value(description),
          ),
        );
  }

  //////////////////////////////////////////////////////
  /// LISTE
  //////////////////////////////////////////////////////

  Future<List<ScolaireOption>> getOptions() async {
    return await (db.select(
      db.scolaireOptions,
    )..orderBy([(t) => OrderingTerm.asc(t.nomOption)])).get();
  }

  //////////////////////////////////////////////////////
  /// RECHERCHE
  //////////////////////////////////////////////////////

  Future<List<ScolaireOption>> rechercherOptions(String motCle) async {
    return await (db.select(
      db.scolaireOptions,
    )..where((tbl) => tbl.nomOption.like('%$motCle%'))).get();
  }

  //////////////////////////////////////////////////////
  /// MODIFIER
  //////////////////////////////////////////////////////

  Future<bool> modifierOption(
    int idOption,
    String nomOption,
    String? description,
  ) async {
    final existing = await (db.select(
      db.scolaireOptions,
    )..where((tbl) => tbl.idOption.equals(idOption))).getSingleOrNull();

    if (existing == null) {
      return false;
    }

    return await db
        .update(db.scolaireOptions)
        .replace(
          existing.copyWith(
            nomOption: nomOption,
            description: Value(description),
            isSynced: false,
            updatedAt: DateTime.now(),
          ),
        );
  }

  //////////////////////////////////////////////////////
  /// SUPPRIMER
  //////////////////////////////////////////////////////

  Future<int> supprimerOption(int idOption) async {
    return await (db.delete(
      db.scolaireOptions,
    )..where((tbl) => tbl.idOption.equals(idOption))).go();
  }

  //////////////////////////////////////////////////////
  /// OPTIONS NON SYNCHRONISEES
  //////////////////////////////////////////////////////

  Future<List<ScolaireOption>> getUnsyncedOptions() async {
    return await (db.select(
      db.scolaireOptions,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  //////////////////////////////////////////////////////
  /// MARQUER SYNCHRONISE
  //////////////////////////////////////////////////////

  Future<void> markAsSynced(int idOption) async {
    await (db.update(db.scolaireOptions)
          ..where((tbl) => tbl.idOption.equals(idOption)))
        .write(ScolaireOptionsCompanion(isSynced: const Value(true)));
  }

  //////////////////////////////////////////////////////
  /// INSERTION DEPUIS SERVEUR
  //////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String nomOption,
    String? description,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.scolaireOptions,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.scolaireOptions)
          .insert(
            ScolaireOptionsCompanion.insert(
              uuid: uuid,
              nomOption: nomOption,
              description: Value(description),
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await db
          .update(db.scolaireOptions)
          .replace(
            existing.copyWith(
              nomOption: nomOption,
              description: Value(description),
              updatedAt: updatedAt,
              isSynced: true,
            ),
          );
    }
  }
}
