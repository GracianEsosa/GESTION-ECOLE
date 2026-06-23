import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../providers/annee_provider.dart';

class AnneePage extends ConsumerStatefulWidget {
  const AnneePage({super.key});

  @override
  ConsumerState<AnneePage> createState() => _AnneePageState();
}

class _AnneePageState extends ConsumerState<AnneePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _libelleController = TextEditingController();
  DateTime _dateDebut = DateTime.now();
  DateTime _dateFin = DateTime.now().add(const Duration(days: 365));
  AnneeScolaire? _editingAnnee;

  @override
  void dispose() {
    _libelleController.dispose();
    super.dispose();
  }

  // Ajout d'un paramètre setStateDialog optionnel pour forcer la mise à jour visuelle du Dialog
  Future<void> _pickDate(
    BuildContext context,
    bool isDebut,
    StateSetter setStateDialog,
  ) async {
    final DateTime initialDate = isDebut ? _dateDebut : _dateFin;
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime(2100);

    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selected != null) {
      // Met à jour à la fois le State de la page ET le State du Dialog
      setState(() {
        if (isDebut) {
          _dateDebut = selected;
          if (_dateFin.isBefore(_dateDebut)) {
            _dateFin = _dateDebut.add(const Duration(days: 365));
          }
        } else {
          _dateFin = selected;
        }
      });
      setStateDialog(
        () {},
      ); // Force le rafraîchissement des textes dans l'AlertDialog
    }
  }

  Future<void> _saveAnnee() async {
    if (!_formKey.currentState!.validate()) return;

    // Validation logique des dates
    if (_dateFin.isBefore(_dateDebut)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La date de fin doit être après la date de début.'),
        ),
      );
      return;
    }

    final service = ref.read(anneeServiceProvider);
    final libelle = _libelleController.text.trim();

    try {
      if (_editingAnnee == null) {
        await service.ajouterAnnee(libelle, _dateDebut, _dateFin);
      } else {
        final modified = await service.modifierAnnee(
          _editingAnnee!.idAnnee,
          libelle,
          _dateDebut,
          _dateFin,
        );

        if (!modified) {
          throw Exception('Impossible de modifier l’année scolaire.');
        }
      }

      ref.refresh(anneesListProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingAnnee == null
                  ? 'Année ajoutée avec succès'
                  : 'Année mise à jour avec succès',
            ),
          ),
        );
      }

      // OPTIONNEL : Déclencher une synchronisation silencieuse automatique vers XAMPP ici si le réseau est disponible
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $error')));
      }
    }
  }

  Future<void> _showAnneeDialog([AnneeScolaire? annee]) async {
    if (annee != null) {
      _editingAnnee = annee;
      _libelleController.text = annee.libelleAnnee;
      _dateDebut = annee.dateDebut;
      _dateFin = annee.dateFin;
    } else {
      _editingAnnee = null;
      _libelleController.clear();
      _dateDebut = DateTime.now();
      _dateFin = DateTime.now().add(const Duration(days: 365));
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        // L'utilisation de StatefulBuilder règle le problème de rafraîchissement des dates dans le formulaire
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                _editingAnnee == null
                    ? 'Ajouter une année'
                    : 'Modifier l’année',
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _libelleController,
                      decoration: const InputDecoration(
                        labelText: 'Libellé de l’année',
                        hintText: 'Ex. 2025-2026',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir un libellé';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () => _pickDate(context, true, setStateDialog),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date de début',
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_dateDebut),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _pickDate(context, false, setStateDialog),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date de fin',
                        ),
                        child: Text(DateFormat('dd/MM/yyyy').format(_dateFin)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: _saveAnnee,
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteAnnee(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer l’année'),
          content: const Text(
            'Voulez-vous vraiment supprimer cette année scolaire ?',
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
      final service = ref.read(anneeServiceProvider);
      await service.supprimerAnnee(id);
      ref.refresh(anneesListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Année supprimée localement')),
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
    final anneesAsync = ref.watch(anneesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Années scolaires'),
        actions: [
          // Optionnel : Un bouton de rafraîchissement/synchro manuelle sur la page
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.refresh(anneesListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAnneeDialog(),
        tooltip: 'Ajouter une année scolaire',
        child: const Icon(Icons.add),
      ),
      body: anneesAsync.when(
        data: (annees) {
          if (annees.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_month, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune année scolaire pour le moment.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cliquez sur + pour ajouter une année.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: annees.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final annee = annees[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    annee.libelleAnnee,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Début : ${DateFormat('dd/MM/yyyy').format(annee.dateDebut)}\nFin : ${DateFormat('dd/MM/yyyy').format(annee.dateFin)}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: 'Modifier',
                        onPressed: () => _showAnneeDialog(annee),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () => _deleteAnnee(annee.idAnnee),
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
          child: Text('Impossible de charger les années scolaires : $error'),
        ),
      ),
    );
  }
}
