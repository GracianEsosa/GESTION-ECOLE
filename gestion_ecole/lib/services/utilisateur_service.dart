import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class UtilisateurService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  UtilisateurService(this.db);

  ////////////////////////////////////////////////////
  /// AJOUTER
  ////////////////////////////////////////////////////

  Future<int> ajouterUtilisateur(UtilisateursCompanion data) async {
    return await db
        .into(db.utilisateurs)
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

  Future<List<Utilisateur>> getUtilisateurs() async {
    return await db.select(db.utilisateurs).get();
  }

  ////////////////////////////////////////////////////
  /// CONNEXION
  ////////////////////////////////////////////////////

  Future<Utilisateur?> getUtilisateurByCredentials(
    String nomUtilisateur,
    String motDePasse,
  ) async {
    final query = db.select(db.utilisateurs)
      ..where(
        (tbl) =>
            tbl.nomUtilisateur.equals(nomUtilisateur) &
            tbl.motDePasse.equals(motDePasse),
      );

    return await query.getSingleOrNull();
  }

  ////////////////////////////////////////////////////
  /// ADMIN PAR DÉFAUT
  ////////////////////////////////////////////////////

  Future<void> ensureDefaultAdmin() async {
    final existingAdmin = await (db.select(
      db.utilisateurs,
    )..where((tbl) => tbl.nomUtilisateur.equals('ADMIN'))).get();

    if (existingAdmin.isEmpty) {
      await ajouterUtilisateur(
        UtilisateursCompanion(
          nomUtilisateur: Value('ADMIN'),
          postnomUtilisateur: Value('ADMIN'),
          motDePasse: Value('ADMIN'),
        ),
      );
    }
  }

  ////////////////////////////////////////////////////
  /// MODIFIER
  ////////////////////////////////////////////////////

  Future<bool> modifierUtilisateur(Utilisateur utilisateur) async {
    return await db
        .update(db.utilisateurs)
        .replace(
          utilisateur.copyWith(isSynced: false, updatedAt: DateTime.now()),
        );
  }

  ////////////////////////////////////////////////////
  /// SUPPRIMER
  ////////////////////////////////////////////////////

  Future<int> supprimerUtilisateur(int idUtilisateur) async {
    return await (db.delete(
      db.utilisateurs,
    )..where((tbl) => tbl.idUtilisateur.equals(idUtilisateur))).go();
  }

  ////////////////////////////////////////////////////
  /// NON SYNCHRONISÉS
  ////////////////////////////////////////////////////

  Future<List<Utilisateur>> getUnsyncedUtilisateurs() async {
    return await (db.select(
      db.utilisateurs,
    )..where((tbl) => tbl.isSynced.equals(false))).get();
  }

  ////////////////////////////////////////////////////
  /// MARQUER COMME SYNCHRONISÉ
  ////////////////////////////////////////////////////

  Future<void> markAsSynced(int idUtilisateur) async {
    await (db.update(db.utilisateurs)
          ..where((tbl) => tbl.idUtilisateur.equals(idUtilisateur)))
        .write(const UtilisateursCompanion(isSynced: Value(true)));
  }

  ////////////////////////////////////////////////////
  /// INSERTION / MISE À JOUR DEPUIS LE SERVEUR
  ////////////////////////////////////////////////////

  Future<void> insertOrUpdateFromServer({
    required String uuid,
    required String nomUtilisateur,
    required String postnomUtilisateur,
    required String motDePasse,
    String? photo,
    required DateTime updatedAt,
  }) async {
    final existing = await (db.select(
      db.utilisateurs,
    )..where((tbl) => tbl.uuid.equals(uuid))).getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.utilisateurs)
          .insert(
            UtilisateursCompanion.insert(
              uuid: uuid,
              nomUtilisateur: nomUtilisateur,
              postnomUtilisateur: postnomUtilisateur,
              motDePasse: motDePasse,
              photo: Value(photo),
              isSynced: const Value(true),
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await (db.update(db.utilisateurs)
            ..where((tbl) => tbl.idUtilisateur.equals(existing.idUtilisateur)))
          .write(
            UtilisateursCompanion(
              nomUtilisateur: Value(nomUtilisateur),
              postnomUtilisateur: Value(postnomUtilisateur),
              motDePasse: Value(motDePasse),
              photo: Value(photo),
              updatedAt: Value(updatedAt),
              isSynced: const Value(true),
            ),
          );
    }
  }
}
