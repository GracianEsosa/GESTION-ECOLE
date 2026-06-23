import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/option_provider.dart';

class OptionPage extends ConsumerStatefulWidget {
  const OptionPage({super.key});

  @override
  ConsumerState<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends ConsumerState<OptionPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////
  /// DIALOG
  //////////////////////////////////////////////////////

  Future<void> _showOptionDialog({ScolaireOption? option}) async {
    final isEditing = option != null;

    _nomController.text = option?.nomOption ?? '';
    _descriptionController.text = option?.description ?? '';

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(isEditing ? 'Modifier une option' : 'Ajouter une option'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l’option',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nomController.text.trim().isEmpty) {
                  return;
                }

                Navigator.pop(context, true);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (saved == true) {
      await _saveOption(option);
    }
  }

  //////////////////////////////////////////////////////
  /// SAVE
  //////////////////////////////////////////////////////

  Future<void> _saveOption(ScolaireOption? option) async {
    final service = ref.read(optionServiceProvider);

    final nom = _nomController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      if (option == null) {
        await service.ajouterOption(
          nom,
          description.isEmpty ? null : description,
        );
      } else {
        await service.modifierOption(
          option.idOption,
          nom,
          description.isEmpty ? null : description,
        );
      }

      ref.refresh(optionsListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              option == null
                  ? 'Option ajoutée avec succès'
                  : 'Option modifiée avec succès',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  //////////////////////////////////////////////////////
  /// DELETE
  //////////////////////////////////////////////////////

  Future<void> _deleteOption(ScolaireOption option) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Suppression'),
          content: Text('Voulez-vous supprimer "${option.nomOption}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Non'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final service = ref.read(optionServiceProvider);

      await service.supprimerOption(option.idOption);

      ref.refresh(optionsListProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Option supprimée')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    }
  }

  //////////////////////////////////////////////////////
  /// UI
  //////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(optionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(optionsListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionDialog(),
        child: const Icon(Icons.add),
      ),
      body: optionsAsync.when(
        data: (options) {
          if (options.isEmpty) {
            return const Center(child: Text('Aucune option enregistrée'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final option = options[index];

              return Card(
                child: ListTile(
                  title: Text(option.nomOption),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (option.description != null) Text(option.description!),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            option.isSynced
                                ? Icons.cloud_done
                                : Icons.cloud_off,
                            size: 18,
                            color: option.isSynced
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            option.isSynced ? 'Synchronisé' : 'Non synchronisé',
                          ),
                        ],
                      ),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showOptionDialog(option: option),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteOption(option),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Center(child: Text('Erreur : $error'));
        },
      ),
    );
  }
}
