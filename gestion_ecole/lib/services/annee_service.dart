import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class AnneeService {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  AnneeService(this.db);

  Future<int> ajouterAnnee(
    String libelle,
    DateTime dateDebut,
    DateTime dateFin,
  ) async {
    return await db.into(db.anneeScolaires).insert(
      AnneeScolairesCompanion.insert(
        uuid: _uuid.v4(),
        libelleAnnee: libelle,
        dateDebut: dateDebut,
        dateFin: dateFin,
      ),
    );
  }

  Future<List<AnneeScolaire>> getAnnees() async {
    return await db.select(db.anneeScolaires).get();
  }

  Future<bool> modifierAnnee(
    int idAnnee,
    String libelle,
    DateTime dateDebut,
    DateTime dateFin,
  ) async {
    final existing = await (db.select(db.anneeScolaires)
          ..where((tbl) => tbl.idAnnee.equals(idAnnee)))
        .getSingleOrNull();

    if (existing == null) {
      return false;
    }

    return await db.update(db.anneeScolaires).replace(
      existing.copyWith(
        libelleAnnee: libelle,
        dateDebut: dateDebut,
        dateFin: dateFin,
        isSynced: false,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<int> supprimerAnnee(int idAnnee) async {
    return await (db.delete(db.anneeScolaires)
          ..where((tbl) => tbl.idAnnee.equals(idAnnee)))
        .go();
  }
}
