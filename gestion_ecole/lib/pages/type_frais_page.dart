// lib/pages/type_frais_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/type_frais_provider.dart';

class TypeFraisPage extends ConsumerStatefulWidget {
  const TypeFraisPage({super.key});

  @override
  ConsumerState<TypeFraisPage> createState() => _TypeFraisPageState();
}

class _TypeFraisPageState extends ConsumerState<TypeFraisPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _libelleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _periodicite = 'mensuel';
  bool _actif = true;
  TypesFrai? _editingType;

  final List<String> _periodicites = [
    'unique',
    'mensuel',
    'trimestriel',
    'annuel',
  ];

  @override
  void dispose() {
    _codeController.dispose();
    _libelleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTypeFrais() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ref.read(typeFraisServiceProvider);
    final code = _codeController.text.trim().toUpperCase();
    final libelle = _libelleController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    try {
      if (_editingType == null) {
        // ✅ Appel avec paramètres positionnels (dans l'ordre)
        await service.ajouterTypeFrais(
          code,
          libelle,
          description,
          _periodicite,
        );
      } else {
        final modified = await service.modifierTypeFrais(
          _editingType!.idTypeFrais,
          code,
          libelle,
          description,
          _periodicite,
          _actif,
        );

        if (!modified) {
          throw Exception('Impossible de modifier le type de frais.');
        }
      }

      ref.refresh(typesFraisListProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingType == null
                  ? 'Type de frais ajouté avec succès'
                  : 'Type de frais mis à jour avec succès',
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

  Future<void> _showTypeFraisDialog([TypesFrai? typeFrais]) async {
    if (typeFrais != null) {
      _editingType = typeFrais;
      _codeController.text = typeFrais.code;
      _libelleController.text = typeFrais.libelle;
      _descriptionController.text = typeFrais.description ?? '';
      _periodicite = typeFrais.periodicite;
      _actif = typeFrais.actif;
    } else {
      _editingType = null;
      _codeController.clear();
      _libelleController.clear();
      _descriptionController.clear();
      _periodicite = 'mensuel';
      _actif = true;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _editingType == null
                ? 'Ajouter un type de frais'
                : 'Modifier le type de frais',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      hintText: 'Ex. SCOL, TRAN, CANT',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir un code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _libelleController,
                    decoration: const InputDecoration(
                      labelText: 'Libellé',
                      hintText: 'Ex. Scolarité, Transport, Cantine',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir un libellé';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optionnel)',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _periodicite,
                    decoration: const InputDecoration(labelText: 'Périodicité'),
                    items: _periodicites.map((p) {
                      return DropdownMenuItem<String>(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _periodicite = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner une périodicité';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Actif'),
                      const SizedBox(width: 12),
                      Switch(
                        value: _actif,
                        onChanged: (value) {
                          setState(() {
                            _actif = value;
                          });
                        },
                      ),
                    ],
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
              onPressed: _saveTypeFrais,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTypeFrais(int idTypeFrais) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le type de frais'),
          content: const Text(
            'Voulez-vous vraiment supprimer ce type de frais ?',
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
      final service = ref.read(typeFraisServiceProvider);
      await service.supprimerTypeFrais(idTypeFrais);
      ref.refresh(typesFraisListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Type de frais supprimé avec succès')),
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

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(typesFraisListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Types de frais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.refresh(typesFraisListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTypeFraisDialog(),
        tooltip: 'Ajouter un type de frais',
        child: const Icon(Icons.add),
      ),
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun type de frais.', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'Cliquez sur + pour ajouter un type de frais.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final type = types[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: type.actif
                        ? Colors.green[100]
                        : Colors.grey[300],
                    child: Text(
                      type.code.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: type.actif
                            ? Colors.green[800]
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  title: Text(
                    '${type.code} - ${type.libelle}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (type.description != null &&
                          type.description!.isNotEmpty)
                        Text(type.description!),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Chip(
                            label: Text(type.periodicite),
                            backgroundColor: Colors.blue[100],
                          ),
                          const SizedBox(width: 8),
                          if (!type.actif)
                            Chip(
                              label: const Text('Inactif'),
                              backgroundColor: Colors.red[100],
                              labelStyle: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Modifier',
                        onPressed: () => _showTypeFraisDialog(type),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () => _deleteTypeFrais(type.idTypeFrais),
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
          child: Text('Impossible de charger les types de frais : $error'),
        ),
      ),
    );
  }
}
