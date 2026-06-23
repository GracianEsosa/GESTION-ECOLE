import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/classe_provider.dart';
import '../providers/option_provider.dart';

class ClassePage extends ConsumerStatefulWidget {
  const ClassePage({super.key});

  @override
  ConsumerState<ClassePage> createState() => _ClassePageState();
}

class _ClassePageState extends ConsumerState<ClassePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomClasseController = TextEditingController();

  final TextEditingController _effectifController = TextEditingController();

  String? _selectedOptionUuid;
  ClassesData? _editingClasse;

  @override
  void dispose() {
    _nomClasseController.dispose();
    _effectifController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////
  /// AJOUT / MODIFICATION
  //////////////////////////////////////////////////////

  Future<void> _saveClasse() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ref.read(classeServiceProvider);

    final nomClasse = _nomClasseController.text.trim();

    final effectif = int.tryParse(_effectifController.text.trim()) ?? 35;

    try {
      if (_editingClasse == null) {
        await service.ajouterClasse(nomClasse, _selectedOptionUuid, effectif);
      } else {
        final modified = await service.modifierClasse(
          _editingClasse!.idClasse,
          nomClasse,
          _selectedOptionUuid,
          effectif,
        );

        if (!modified) {
          throw Exception('Impossible de modifier la classe.');
        }
      }

      ref.invalidate(classesListProvider);

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingClasse == null
                  ? 'Classe ajoutée avec succès'
                  : 'Classe mise à jour avec succès',
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
  /// DIALOGUE AJOUT / MODIFICATION
  //////////////////////////////////////////////////////

  void _openClasseDialog([ClassesData? classe]) {
    if (classe != null) {
      _editingClasse = classe;

      _nomClasseController.text = classe.nomClasse;

      _effectifController.text = classe.effectifMax.toString();

      _selectedOptionUuid = classe.idOptionUuid;
    } else {
      _editingClasse = null;

      _nomClasseController.clear();

      _effectifController.text = '35';

      _selectedOptionUuid = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        final optionsAsync = ref.watch(optionsListProvider);

        return AlertDialog(
          title: Text(
            _editingClasse == null
                ? 'Ajouter une classe'
                : 'Modifier la classe',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomClasseController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de la classe',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir le nom de la classe';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _effectifController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Effectif maximum',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir un effectif';
                      }

                      final parsed = int.tryParse(value);

                      if (parsed == null || parsed <= 0) {
                        return 'Valeur invalide';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  optionsAsync.when(
                    data: (options) {
                      return DropdownButtonFormField<String?>(
                        value: _selectedOptionUuid,
                        decoration: const InputDecoration(
                          labelText: 'Option associée',
                        ),
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Sans option'),
                          ),
                          ...options.map(
                            (option) => DropdownMenuItem<String?>(
                              value: option.uuid,
                              child: Text(option.nomOption),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedOptionUuid = value;
                          });
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('Erreur : $e'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: _saveClasse,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////////////////
  /// SUPPRESSION
  //////////////////////////////////////////////////////

  Future<void> _deleteClasse(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la classe'),
        content: const Text('Voulez-vous vraiment supprimer cette classe ?'),
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
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(classeServiceProvider).supprimerClasse(id);

      ref.invalidate(classesListProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Classe supprimée')));
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
    final classesAsync = ref.watch(classesListProvider);

    final optionsAsync = ref.watch(optionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(classesListProvider);
              ref.invalidate(optionsListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openClasseDialog(),
        child: const Icon(Icons.add),
      ),
      body: classesAsync.when(
        data: (classes) {
          if (classes.isEmpty) {
            return const Center(child: Text('Aucune classe disponible'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classe = classes[index];

              final optionNom = optionsAsync.maybeWhen(
                data: (options) {
                  final option = options
                      .where((o) => o.uuid == classe.idOptionUuid)
                      .firstOrNull;

                  return option?.nomOption ?? 'Aucune option';
                },
                orElse: () => 'Chargement...',
              );

              return Card(
                child: ListTile(
                  title: Text(classe.nomClasse),
                  subtitle: Text(
                    'Option : $optionNom\n'
                    'Effectif max : ${classe.effectifMax}',
                  ),
                  isThreeLine: true,
                  leading: Icon(
                    classe.isSynced ? Icons.cloud_done : Icons.cloud_upload,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openClasseDialog(classe),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteClasse(classe.idClasse),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}
