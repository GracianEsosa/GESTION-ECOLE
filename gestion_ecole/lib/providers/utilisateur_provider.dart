import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/utilisateur_service.dart';

////////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////////

final utilisateurServiceProvider = Provider<UtilisateurService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return UtilisateurService(db);
});

////////////////////////////////////////////////////////
/// LISTE DES UTILISATEURS
////////////////////////////////////////////////////////

final utilisateursListProvider = FutureProvider<List<Utilisateur>>((ref) async {
  final service = ref.watch(utilisateurServiceProvider);
  return await service.getUtilisateurs();
});

////////////////////////////////////////////////////////
/// UTILISATEURS NON SYNCHRONISÉS
////////////////////////////////////////////////////////

final unsyncedUtilisateursProvider = FutureProvider<List<Utilisateur>>((
  ref,
) async {
  final service = ref.watch(utilisateurServiceProvider);
  return await service.getUnsyncedUtilisateurs();
});

////////////////////////////////////////////////////////
/// RAFRAICHIR
////////////////////////////////////////////////////////

final refreshUtilisateursProvider = Provider((ref) {
  return () {
    ref.refresh(utilisateursListProvider);
    ref.refresh(unsyncedUtilisateursProvider);
  };
});

////////////////////////////////////////////////////////
/// AJOUTER
////////////////////////////////////////////////////////

final addUtilisateurProvider =
    FutureProvider.family<void, UtilisateursCompanion>((
      ref,
      utilisateur,
    ) async {
      final service = ref.watch(utilisateurServiceProvider);

      await service.ajouterUtilisateur(utilisateur);

      ref.refresh(utilisateursListProvider);
      ref.refresh(unsyncedUtilisateursProvider);
    });

////////////////////////////////////////////////////////
/// MODIFIER
////////////////////////////////////////////////////////

final updateUtilisateurProvider = FutureProvider.family<void, Utilisateur>((
  ref,
  utilisateur,
) async {
  final service = ref.watch(utilisateurServiceProvider);

  await service.modifierUtilisateur(utilisateur);

  ref.refresh(utilisateursListProvider);
  ref.refresh(unsyncedUtilisateursProvider);
});

////////////////////////////////////////////////////////
/// SUPPRIMER
////////////////////////////////////////////////////////

final deleteUtilisateurProvider = FutureProvider.family<void, int>((
  ref,
  idUtilisateur,
) async {
  final service = ref.watch(utilisateurServiceProvider);

  await service.supprimerUtilisateur(idUtilisateur);

  ref.refresh(utilisateursListProvider);
  ref.refresh(unsyncedUtilisateursProvider);
});

////////////////////////////////////////////////////////
/// MARQUER SYNCHRONISÉ
////////////////////////////////////////////////////////

final markUtilisateurSyncedProvider = FutureProvider.family<void, int>((
  ref,
  idUtilisateur,
) async {
  final service = ref.watch(utilisateurServiceProvider);

  await service.markAsSynced(idUtilisateur);

  ref.refresh(utilisateursListProvider);
  ref.refresh(unsyncedUtilisateursProvider);
});

////////////////////////////////////////////////////////
/// INSERTION / MISE À JOUR DEPUIS SERVEUR
////////////////////////////////////////////////////////

final upsertUtilisateurFromServerProvider =
    FutureProvider.family<
      void,
      ({
        String uuid,
        String nomUtilisateur,
        String postnomUtilisateur,
        String motDePasse,
        String? photo,
        DateTime updatedAt,
      })
    >((ref, data) async {
      final service = ref.watch(utilisateurServiceProvider);

      await service.insertOrUpdateFromServer(
        uuid: data.uuid,
        nomUtilisateur: data.nomUtilisateur,
        postnomUtilisateur: data.postnomUtilisateur,
        motDePasse: data.motDePasse,
        photo: data.photo,
        updatedAt: data.updatedAt,
      );

      ref.refresh(utilisateursListProvider);
      ref.refresh(unsyncedUtilisateursProvider);
    });

////////////////////////////////////////////////////////
/// CONNEXION
////////////////////////////////////////////////////////

final connexionProvider =
    FutureProvider.family<
      Utilisateur?,
      ({String nomUtilisateur, String motDePasse})
    >((ref, credentials) async {
      final service = ref.watch(utilisateurServiceProvider);

      return await service.getUtilisateurByCredentials(
        credentials.nomUtilisateur,
        credentials.motDePasse,
      );
    });
