import 'package:drift/drift.dart';
import 'database_connection.dart';

part 'app_database.g.dart';

////////////////////////////////////////////////////////////
/// TABLE ANNEE SCOLAIRE
////////////////////////////////////////////////////////////
class AnneeScolaires extends Table {
  IntColumn get idAnnee => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get libelleAnnee => text()();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE OPTIONS
////////////////////////////////////////////////////////////
class ScolaireOptions extends Table {
  IntColumn get idOption => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nomOption => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE CLASSES
////////////////////////////////////////////////////////////
class Classes extends Table {
  IntColumn get idClasse => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nomClasse => text()();
  TextColumn get idOptionUuid =>
      text().nullable().references(ScolaireOptions, #uuid)();
  IntColumn get effectifMax => integer().withDefault(const Constant(35))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE INSCRIPTIONS
////////////////////////////////////////////////////////////
class EleveInscriptions extends Table {
  IntColumn get idInscription => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nomEleve => text()();
  TextColumn get prenomEleve => text()();
  DateTimeColumn get dateNaissance => dateTime()();
  TextColumn get sexe => text()();
  TextColumn get idAnneeUuid => text().references(AnneeScolaires, #uuid)();
  TextColumn get idClasseUuid => text().references(Classes, #uuid)();
  DateTimeColumn get dateInscription =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get statutInscription =>
      text().withDefault(const Constant('Pré-inscription'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE PAIEMENTS (MODIFIÉE : ajout de idFactureUuid)
////////////////////////////////////////////////////////////
class PaiementInscriptions extends Table {
  IntColumn get idPaiement => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get idInscriptionUuid =>
      text().references(EleveInscriptions, #uuid)();
  // 🔥 Lien vers le tarif (qui contient déjà le trimestre)
  TextColumn get idTarifFraisUuid => text().references(TarifsFrais, #uuid)();
  RealColumn get montantPaye => real()();
  DateTimeColumn get datePaiement =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get modePaiement => text()();
  TextColumn get motifPaiement => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE UTILISATEURS
////////////////////////////////////////////////////////////
class Utilisateurs extends Table {
  IntColumn get idUtilisateur => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get nomUtilisateur => text()();
  TextColumn get postnomUtilisateur => text()();
  TextColumn get motDePasse => text()();
  TextColumn get photo => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

// ============================================================
// 🆕 NOUVELLES TABLES POUR LA GESTION DES FRAIS SCOLAIRES
// ============================================================

////////////////////////////////////////////////////////////
/// TABLE TYPES DE FRAIS
////////////////////////////////////////////////////////////
class TypesFrais extends Table {
  IntColumn get idTypeFrais => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get code => text()();
  TextColumn get libelle => text()();
  TextColumn get description => text().nullable()();
  TextColumn get periodicite => text().withDefault(const Constant('mensuel'))();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
// ====== TarifsFrais avec trimestre ======
class TarifsFrais extends Table {
  IntColumn get idTarif => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get idTypeFraisUuid => text().references(TypesFrais, #uuid)();
  TextColumn get idAnneeUuid => text().references(AnneeScolaires, #uuid)();
  TextColumn get idClasseUuid => text().nullable().references(Classes, #uuid)();
  // 🔥 Trimestre (1,2,3) - validation dans le service
  IntColumn get trimestre => integer().withDefault(const Constant(1))();
  RealColumn get montant => real()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE FACTURES
////////////////////////////////////////////////////////////

// ============================================================
/// DATABASE
// ============================================================
@DriftDatabase(
  tables: [
    AnneeScolaires,
    ScolaireOptions,
    Classes,
    EleveInscriptions,
    PaiementInscriptions,
    Utilisateurs,
    TypesFrais, // 🆕
    TarifsFrais, // 🆕
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDatabaseConnection());

  @override
  int get schemaVersion => 4; // incrémenté
}
