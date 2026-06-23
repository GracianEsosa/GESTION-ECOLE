import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../database/app_database.dart';
import '../routes/api_config.dart';

class SyncService {
  final AppDatabase db;
  final http.Client _client = http.Client();

  SyncService(this.db);

  // Récupérer toutes les données non synchronisées
  Future<SyncData> getUnsyncedData() async {
    final unsyncedAnnees = await (db.select(
      db.anneeScolaires,
    )..where((t) => t.isSynced.equals(false))).get();

    final unsyncedOptions = await (db.select(
      db.scolaireOptions,
    )..where((t) => t.isSynced.equals(false))).get();

    final unsyncedClasses = await (db.select(
      db.classes,
    )..where((t) => t.isSynced.equals(false))).get();

    final unsyncedInscriptions = await (db.select(
      db.eleveInscriptions,
    )..where((t) => t.isSynced.equals(false))).get();

    final unsyncedPaiements = await (db.select(
      db.paiementInscriptions,
    )..where((t) => t.isSynced.equals(false))).get();

    final unsyncedUtilisateurs = await (db.select(
      db.utilisateurs,
    )..where((t) => t.isSynced.equals(false))).get();

    return SyncData(
      annees: unsyncedAnnees,
      options: unsyncedOptions,
      classes: unsyncedClasses,
      inscriptions: unsyncedInscriptions,
      paiements: unsyncedPaiements,
      utilisateurs: unsyncedUtilisateurs,
    );
  }

  // Helper pour vérifier si le statut HTTP est OK et si le JSON est valide
  bool _isResponseSuccessful(http.Response response) {
    if (response.statusCode != 200) return false;
    try {
      final resData = jsonDecode(response.body);
      if (resData is Map &&
          (resData['success'] == false || resData['status'] == 'error')) {
        return false;
      }
    } catch (_) {
      // Si ce n'est pas un JSON valide mais que le status est 200, on tolère
    }
    return true;
  }

  // Envoyer les années au serveur
  Future<bool> _syncAnnees(List<AnneeScolaire> annees) async {
    if (annees.isEmpty) {
      print("Aucune année à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': annees.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC ANNEES ===");
      print("URL : ${ApiConfig.syncAnnees}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncAnnees),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync annees : $e");
      return false;
    }
  }

  // Envoyer les options au serveur
  Future<bool> _syncOptions(List<ScolaireOption> options) async {
    if (options.isEmpty) {
      print("Aucune option à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': options.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC OPTIONS ===");
      print("URL : ${ApiConfig.syncOptions}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncOptions),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync options : $e");
      return false;
    }
  }

  // Envoyer les classes au serveur
  Future<bool> _syncClasses(List<ClassesData> classes) async {
    if (classes.isEmpty) {
      print("Aucune classe à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': classes.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC CLASSES ===");
      print("URL : ${ApiConfig.syncClasses}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncClasses),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync classes : $e");
      return false;
    }
  }

  // Envoyer les inscriptions au serveur
  Future<bool> _syncInscriptions(List<EleveInscription> inscriptions) async {
    if (inscriptions.isEmpty) {
      print("Aucune inscription à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': inscriptions.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC INSCRIPTIONS ===");
      print("URL : ${ApiConfig.syncInscriptions}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncInscriptions),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync inscriptions : $e");
      return false;
    }
  }

  // Envoyer les paiements au serveur
  Future<bool> _syncPaiements(List<PaiementInscription> paiements) async {
    if (paiements.isEmpty) {
      print("Aucun paiement à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': paiements.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC PAIEMENTS ===");
      print("URL : ${ApiConfig.syncPaiements}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncPaiements),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync paiements : $e");
      return false;
    }
  }

  // Envoyer les utilisateurs au serveur
  Future<bool> _syncUtilisateurs(List<Utilisateur> utilisateurs) async {
    if (utilisateurs.isEmpty) {
      print("Aucun utilisateur à synchroniser");
      return true;
    }

    try {
      final body = {
        'action': 'sync',
        'data': utilisateurs.map((e) => e.toJson()).toList(),
      };

      print("=== SYNC UTILISATEURS ===");
      print("URL : ${ApiConfig.syncUtilisateurs}");
      print("DONNEES : ${jsonEncode(body)}");

      final response = await _client.post(
        Uri.parse(ApiConfig.syncUtilisateurs),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("CODE : ${response.statusCode}");
      print("REPONSE : ${response.body}");

      return _isResponseSuccessful(response);
    } catch (e) {
      print("Erreur sync utilisateurs : $e");
      return false;
    }
  }

  // Synchronisation complète et granulaire
  Future<bool> syncToServer() async {
    try {
      final unsyncedData = await getUnsyncedData();

      // Synchronisation des années
      final anneesOk = await _syncAnnees(unsyncedData.annees);
      if (anneesOk && unsyncedData.annees.isNotEmpty) {
        await _markAnneesAsSynced(
          unsyncedData.annees.map((e) => e.uuid).toList(),
        );
      }

      // Synchronisation des options
      final optionsOk = await _syncOptions(unsyncedData.options);
      if (optionsOk && unsyncedData.options.isNotEmpty) {
        await _markOptionsAsSynced(
          unsyncedData.options.map((e) => e.uuid).toList(),
        );
      }

      // Synchronisation des classes
      final classesOk = await _syncClasses(unsyncedData.classes);
      if (classesOk && unsyncedData.classes.isNotEmpty) {
        await _markClassesAsSynced(
          unsyncedData.classes.map((e) => e.uuid).toList(),
        );
      }

      // Synchronisation des inscriptions
      final inscriptionsOk = await _syncInscriptions(unsyncedData.inscriptions);

      if (inscriptionsOk && unsyncedData.inscriptions.isNotEmpty) {
        await _markInscriptionsAsSynced(
          unsyncedData.inscriptions.map((e) => e.uuid).toList(),
        );
      }

      // Synchronisation des paiements
      final paiementsOk = await _syncPaiements(unsyncedData.paiements);

      if (paiementsOk && unsyncedData.paiements.isNotEmpty) {
        await _markPaiementsAsSynced(
          unsyncedData.paiements.map((e) => e.uuid).toList(),
        );
      }

      // Synchronisation des utilisateurs
      final utilisateursOk = await _syncUtilisateurs(unsyncedData.utilisateurs);

      if (utilisateursOk && unsyncedData.utilisateurs.isNotEmpty) {
        await _markUtilisateursAsSynced(
          unsyncedData.utilisateurs.map((e) => e.uuid).toList(),
        );
      }

      final allOk =
          anneesOk &&
          optionsOk &&
          classesOk &&
          inscriptionsOk &&
          paiementsOk &&
          utilisateursOk;

      // Télécharger les données du serveur vers Drift
      if (allOk) {
        await _downloadServerData();
      }

      return allOk;
    } catch (e) {
      print('Erreur de synchronisation globale: $e');
      return false;
    }
  }

  // APLOAD ANNEES
  Future<void> _downloadAnnees() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncAnnees),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.anneeScolaires)
              .insertOnConflictUpdate(
                AnneeScolairesCompanion.insert(
                  uuid: row['uuid'],
                  libelleAnnee: row['libelle_annee'],
                  dateDebut: DateTime.parse(row['date_debut']),
                  dateFin: DateTime.parse(row['date_fin']),
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement années : $e');
    }
  }

  // UPLOAD OPTIONS

  Future<void> _downloadOptions() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncOptions),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.scolaireOptions)
              .insertOnConflictUpdate(
                ScolaireOptionsCompanion.insert(
                  uuid: row['uuid'],
                  nomOption: row['nom_option'],
                  description: Value(row['description']),
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement options : $e');
    }
  }

  // UPLOAD CLASSES

  Future<void> _downloadClasses() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncClasses),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.classes)
              .insert(
                ClassesCompanion(
                  uuid: Value(row['uuid']),
                  nomClasse: Value(row['nom_classe']),
                  idOptionUuid: Value(row['id_option_uuid']),
                  effectifMax: Value(
                    int.tryParse(row['effectif_max'].toString()) ?? 35,
                  ),
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement classes : $e');
    }
  }

  // UPLOAD INCRIPRIONS
  Future<void> _downloadInscriptions() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncInscriptions),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.eleveInscriptions)
              .insert(
                EleveInscriptionsCompanion(
                  uuid: Value(row['uuid']),
                  nomEleve: Value(row['nom_eleve']),
                  prenomEleve: Value(row['prenom_eleve']),
                  dateNaissance: Value(DateTime.parse(row['date_naissance'])),
                  sexe: Value(row['sexe']),
                  idAnneeUuid: Value(row['id_annee_uuid']),
                  idClasseUuid: Value(row['id_classe_uuid']),
                  dateInscription: Value(
                    DateTime.parse(row['date_inscription']),
                  ),
                  statutInscription: Value(
                    row['statut_inscription'] ?? 'Pré-inscription',
                  ),
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement inscriptions : $e');
    }
  }

  //UPLOAD PAIEMENTS

  Future<void> _downloadPaiements() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncPaiements),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.paiementInscriptions)
              .insertOnConflictUpdate(
                PaiementInscriptionsCompanion.insert(
                  uuid: row['uuid'],
                  idInscriptionUuid: row['id_inscription_uuid'],
                  montantPaye: double.parse(row['montant_paye'].toString()),
                  datePaiement: Value(
                    DateTime.parse(row['date_paiement'].toString()),
                  ),
                  modePaiement: row['mode_paiement'],
                  motifPaiement: row['motif_paiement'],
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement paiements : $e');
    }
  }

  // UPLOAD UTILISATEURS

  Future<void> _downloadUtilisateurs() async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConfig.syncUtilisateurs),
        body: jsonEncode({'action': 'download'}),
        headers: {'Content-Type': 'application/json'},
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final List data = json['donnees_serveur'];

        for (final row in data) {
          await db
              .into(db.utilisateurs)
              .insert(
                UtilisateursCompanion(
                  uuid: Value(row['uuid']),
                  nomUtilisateur: Value(row['nom_utilisateur']),
                  postnomUtilisateur: Value(row['postnom_utilisateur']),
                  motDePasse: Value(row['mot_de_passe']),
                  photo: Value(row['photo']),
                  isSynced: const Value(true),
                  updatedAt: Value(DateTime.parse(row['updated_at'])),
                ),
                mode: InsertMode.insertOrReplace,
              );
        }
      }
    } catch (e) {
      print('Erreur téléchargement utilisateurs : $e');
    }
  }

  Future<void> _downloadServerData() async {
    await _downloadAnnees();
    await _downloadOptions();
    await _downloadClasses();
    await _downloadInscriptions();
    await _downloadPaiements();
    await _downloadUtilisateurs();
  }

  // Méthodes de marquage spécifiques par liste d'UUIDs
  Future<void> _markAnneesAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.anneeScolaires)..where((t) => t.uuid.isIn(uuids)))
        .write(const AnneeScolairesCompanion(isSynced: Value(true)));
  }

  Future<void> _markOptionsAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.scolaireOptions)..where((t) => t.uuid.isIn(uuids)))
        .write(const ScolaireOptionsCompanion(isSynced: Value(true)));
  }

  Future<void> _markClassesAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.classes)..where((t) => t.uuid.isIn(uuids))).write(
      const ClassesCompanion(isSynced: Value(true)),
    );
  }

  Future<void> _markInscriptionsAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.eleveInscriptions)..where((t) => t.uuid.isIn(uuids)))
        .write(const EleveInscriptionsCompanion(isSynced: Value(true)));
  }

  Future<void> _markPaiementsAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.paiementInscriptions)..where((t) => t.uuid.isIn(uuids)))
        .write(const PaiementInscriptionsCompanion(isSynced: Value(true)));
  }

  Future<void> _markUtilisateursAsSynced(List<String> uuids) async {
    if (uuids.isEmpty) return;
    await (db.update(db.utilisateurs)..where((t) => t.uuid.isIn(uuids))).write(
      const UtilisateursCompanion(isSynced: Value(true)),
    );
  }

  // Fermer le client HTTP
  void dispose() {
    _client.close();
  }
}

// Classe de données pour la synchronisation
class SyncData {
  final List<AnneeScolaire> annees;
  final List<ScolaireOption> options;
  final List<ClassesData> classes;
  final List<EleveInscription> inscriptions;
  final List<PaiementInscription> paiements;
  final List<Utilisateur> utilisateurs;

  SyncData({
    required this.annees,
    required this.options,
    required this.classes,
    required this.inscriptions,
    required this.paiements,
    required this.utilisateurs,
  });
}
