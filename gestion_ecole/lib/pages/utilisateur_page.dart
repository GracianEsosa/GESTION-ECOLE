import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../database/app_database.dart';
import '../providers/utilisateur_provider.dart';
import '../utils/file_image_provider.dart';

class UtilisateurPage extends ConsumerStatefulWidget {
  const UtilisateurPage({super.key});

  @override
  ConsumerState<UtilisateurPage> createState() => _UtilisateurPageState();
}

class _UtilisateurPageState extends ConsumerState<UtilisateurPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _postnomController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();
  Utilisateur? _editingUtilisateur;

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _motDePasseController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  Future<void> _saveUtilisateur() async {
    if (!_formKey.currentState!.validate()) return;

    final nom = _nomController.text.trim();
    final postnom = _postnomController.text.trim();
    final motDePasse = _motDePasseController.text.trim();
    final photo = _photoController.text.trim();

    try {
      if (_editingUtilisateur == null) {
        await ref.read(
          addUtilisateurProvider(
            UtilisateursCompanion(
              nomUtilisateur: drift.Value(nom),
              postnomUtilisateur: drift.Value(postnom),
              motDePasse: drift.Value(motDePasse),
              photo: drift.Value(photo.isEmpty ? null : photo),
            ),
          ).future,
        );
      } else {
        final updatedUser = _editingUtilisateur!.copyWith(
          nomUtilisateur: nom,
          postnomUtilisateur: postnom,
          motDePasse: motDePasse,
          photo: drift.Value(photo.isEmpty ? null : photo),
          isSynced: false,
          updatedAt: DateTime.now(),
        );
        await ref.read(updateUtilisateurProvider(updatedUser).future);
      }

      ref.read(refreshUtilisateursProvider)();

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingUtilisateur == null
                  ? 'Utilisateur ajouté avec succès'
                  : 'Utilisateur mis à jour avec succès',
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $error')));
      }
    }
  }

  void _openUtilisateurDialog([Utilisateur? utilisateur]) {
    if (utilisateur != null) {
      _editingUtilisateur = utilisateur;
      _nomController.text = utilisateur.nomUtilisateur;
      _postnomController.text = utilisateur.postnomUtilisateur;
      _motDePasseController.text = utilisateur.motDePasse;
      _photoController.text = utilisateur.photo ?? '';
    } else {
      _editingUtilisateur = null;
      _nomController.clear();
      _postnomController.clear();
      _motDePasseController.clear();
      _photoController.clear();
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _editingUtilisateur == null
                ? 'Ajouter un utilisateur'
                : 'Modifier l’utilisateur',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir le nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _postnomController,
                    decoration: const InputDecoration(labelText: 'Postnom'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir le postnom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _motDePasseController,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir le mot de passe';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _photoController,
                    decoration: const InputDecoration(
                      labelText: 'Photo (URL ou chemin)',
                      hintText: 'Ex. https://... ou chemin local',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: _saveUtilisateur,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUtilisateur(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer l’utilisateur'),
          content: const Text(
            'Voulez-vous vraiment supprimer cet utilisateur ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await ref.read(deleteUtilisateurProvider(id).future);
      ref.read(refreshUtilisateursProvider)();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Utilisateur supprimé')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $error')));
      }
    }
  }

  Widget _buildAvatar(Utilisateur utilisateur) {
    final photo = utilisateur.photo?.trim();
    if (photo != null && photo.isNotEmpty) {
      if (photo.startsWith('http://') || photo.startsWith('https://')) {
        return CircleAvatar(backgroundImage: NetworkImage(photo));
      }

      final localPath = photo.startsWith('file://')
          ? photo.replaceFirst('file://', '')
          : photo;
      final imageProvider = fileImageProvider(localPath);
      if (imageProvider != null) {
        return CircleAvatar(backgroundImage: imageProvider);
      }
    }

    final initials =
        '${utilisateur.nomUtilisateur.isNotEmpty ? utilisateur.nomUtilisateur[0] : ''}${utilisateur.postnomUtilisateur.isNotEmpty ? utilisateur.postnomUtilisateur[0] : ''}'
            .toUpperCase();
    return CircleAvatar(child: Text(initials));
  }

  @override
  Widget build(BuildContext context) {
    final utilisateursAsync = ref.watch(utilisateursListProvider);
    final refresh = ref.watch(refreshUtilisateursProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () => refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUtilisateurDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un utilisateur',
      ),
      body: utilisateursAsync.when(
        data: (utilisateurs) {
          if (utilisateurs.isEmpty) {
            return const Center(
              child: Text(
                'Aucun utilisateur trouvé. Appuyez sur + pour en ajouter.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: utilisateurs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final utilisateur = utilisateurs[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: _buildAvatar(utilisateur),
                  title: Text(
                    '${utilisateur.nomUtilisateur} ${utilisateur.postnomUtilisateur}',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mot de passe : ${'*' * utilisateur.motDePasse.length}',
                      ),
                      if (!utilisateur.isSynced)
                        const Chip(
                          label: Text('Non synchronisé'),
                          backgroundColor: Colors.orangeAccent,
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!utilisateur.isSynced)
                        IconButton(
                          icon: const Icon(Icons.cloud_upload),
                          tooltip: 'Marquer synchronisé',
                          onPressed: () async {
                            try {
                              await ref.read(
                                markUtilisateurSyncedProvider(
                                  utilisateur.idUtilisateur,
                                ).future,
                              );
                              refresh();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Utilisateur marqué synchronisé',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur : $e')),
                                );
                              }
                            }
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Modifier',
                        onPressed: () => _openUtilisateurDialog(utilisateur),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Supprimer',
                        onPressed: () =>
                            _deleteUtilisateur(utilisateur.idUtilisateur),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Impossible de charger les utilisateurs : $error'),
        ),
      ),
    );
  }
}
