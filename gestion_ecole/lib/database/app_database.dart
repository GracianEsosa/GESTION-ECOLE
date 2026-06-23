import 'package:drift/drift.dart';
import 'database_connection.dart';

part 'app_database.g.dart';

////////////////////////////////////////////////////////////
/// TABLE ANNEE SCOLAIRE
////////////////////////////////////////////////////////////
class AnneeScolaires extends Table {
  IntColumn get idAnnee => integer().autoIncrement()();
  TextColumn get uuid => text().unique()(); // Clé de synchronisation principale
  TextColumn get libelleAnnee => text()();
  DateTimeColumn get dateDebut => dateTime()();
  DateTimeColumn get dateFin => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

////////////////////////////////////////////////////////////
/// TABLE OPTIONS (Modifié pour éviter les conflits de nom)
////////////////////////////////////////////////////////////
class ScolaireOptions extends Table {
  IntColumn get idOption => integer().autoIncrement()();
  TextColumn get uuid => text().unique()(); // Clé de synchronisation principale
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

  // Correction : La relation se fait maintenant sur l'UUID textuel pour la synchro
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

  // Correction : Relations basées sur les UUID
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
/// TABLE PAIEMENTS
////////////////////////////////////////////////////////////
class PaiementInscriptions extends Table {
  IntColumn get idPaiement => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();

  // Correction : Relation basée sur l'UUID
  TextColumn get idInscriptionUuid =>
      text().references(EleveInscriptions, #uuid)();

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

////////////////////////////////////////////////////////////
/// DATABASE
////////////////////////////////////////////////////////////
@DriftDatabase(
  tables: [
    AnneeScolaires,
    ScolaireOptions,
    Classes,
    EleveInscriptions,
    PaiementInscriptions,
    Utilisateurs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDatabaseConnection());

  @override
  int get schemaVersion => 2;
}
