import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';

class EcoleInfo {
  const EcoleInfo({
    required this.nom,
    this.adresse,
    this.telephone,
    this.email,
    this.devise = 'FCFA',
    this.logoPath,
  });

  final String nom;
  final String? adresse;
  final String? telephone;
  final String? email;
  final String devise;
  final String? logoPath;
}

class EcoleService {
  EcoleService(this.db);
  final AppDatabase db;

  Future<EcoleInfo?> getEcole() async {
    final row = await db
        .customSelect('SELECT * FROM ecoles ORDER BY id_ecole LIMIT 1')
        .getSingleOrNull();
    if (row == null) return null;
    return EcoleInfo(
      nom: row.read<String>('nom'),
      adresse: row.readNullable<String>('adresse'),
      telephone: row.readNullable<String>('telephone'),
      email: row.readNullable<String>('email'),
      devise: row.read<String>('devise'),
      logoPath: row.readNullable<String>('logo_path'),
    );
  }

  Future<void> enregistrer(EcoleInfo ecole) async {
    final existing = await getEcole();
    final variables = [
      Variable<String>(ecole.nom),
      Variable<String?>(ecole.adresse),
      Variable<String?>(ecole.telephone),
      Variable<String?>(ecole.email),
      Variable<String>(ecole.devise),
      Variable<String?>(ecole.logoPath),
      Variable<int>(DateTime.now().millisecondsSinceEpoch),
    ];
    if (existing == null) {
      await db.customStatement(
        'INSERT INTO ecoles (nom, adresse, telephone, email, devise, logo_path, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        variables,
      );
    } else {
      await db.customStatement(
        'UPDATE ecoles SET nom = ?, adresse = ?, telephone = ?, email = ?, devise = ?, logo_path = ?, updated_at = ?',
        variables,
      );
    }
  }
}
