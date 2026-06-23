import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '../database/app_database.dart';
import '../providers/annee_provider.dart';
import '../providers/classe_provider.dart';
import '../providers/inscription_provider.dart';
import '../providers/option_provider.dart';

class InscriptionPage extends ConsumerStatefulWidget {
  const InscriptionPage({super.key});

  @override
  ConsumerState<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends ConsumerState<InscriptionPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _statutController = TextEditingController(text: 'Pré-inscription');

  DateTime _dateNaissance = DateTime.now();
  String _sexe = 'Masculin';

  String? _selectedAnneeUuid;
  String? _selectedClasseUuid;

  EleveInscription? _editingInscription;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _statutController.dispose();
    super.dispose();
  }

  // Méthode pour choisir une date de naissance
  Future<void> _pickDateNaissance(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateNaissance,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateNaissance) {
      setState(() {
        _dateNaissance = picked;
      });
    }
  }

  Future<void> _saveInscription() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAnneeUuid == null || _selectedClasseUuid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une année et une classe'),
        ),
      );
      return;
    }

    final service = ref.read(inscriptionServiceProvider);

    try {
      if (_editingInscription == null) {
        // Insertion
        await service.ajouterInscription(
          EleveInscriptionsCompanion.insert(
            uuid: _generateUuid(), // À implémenter selon votre générateur
            nomEleve: _nomController.text.trim(),
            prenomEleve: _prenomController.text.trim(),
            dateNaissance: _dateNaissance,
            sexe: _sexe,
            idAnneeUuid: _selectedAnneeUuid!,
            idClasseUuid: _selectedClasseUuid!,
            statutInscription: drift.Value(_statutController.text.trim()),
          ),
        );
      } else {
        // Modification : on crée un nouvel objet EleveInscription à partir de l'existant
        final updatedInscription = _editingInscription!.copyWith(
          nomEleve: _nomController.text.trim(),
          prenomEleve: _prenomController.text.trim(),
          dateNaissance: _dateNaissance,
          sexe: _sexe,
          idAnneeUuid: _selectedAnneeUuid!,
          idClasseUuid: _selectedClasseUuid!,
          statutInscription: _statutController.text.trim(),
        );
        await service.modifierInscription(updatedInscription);
      }

      ref.invalidate(inscriptionsListProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingInscription == null
                  ? 'Inscription enregistrée'
                  : 'Inscription modifiée',
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

  // Helper à adapter : utilisez votre propre générateur (ex: Uuid().v4())
  String _generateUuid() => DateTime.now().millisecondsSinceEpoch.toString();

  void _openInscriptionDialog([EleveInscription? inscription]) {
    if (inscription != null) {
      _editingInscription = inscription;
      _nomController.text = inscription.nomEleve;
      _prenomController.text = inscription.prenomEleve;
      _statutController.text = inscription.statutInscription;
      _dateNaissance = inscription.dateNaissance;
      _sexe = inscription.sexe;
      _selectedAnneeUuid = inscription.idAnneeUuid;
      _selectedClasseUuid = inscription.idClasseUuid;
    } else {
      _editingInscription = null;
      _nomController.clear();
      _prenomController.clear();
      _statutController.text = 'Pré-inscription';
      _dateNaissance = DateTime.now();
      _sexe = 'Masculin';
      _selectedAnneeUuid = null;
      _selectedClasseUuid = null;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        final anneesAsync = ref.watch(anneesListProvider);
        final classesAsync = ref.watch(classesListProvider);
        final optionsAsync = ref.watch(optionsListProvider);

        return AlertDialog(
          title: Text(
            _editingInscription == null
                ? 'Ajouter une inscription'
                : 'Modifier l\'inscription',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom de l\'élève',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Veuillez saisir le nom'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _prenomController,
                    decoration: const InputDecoration(
                      labelText: 'Prénom de l\'élève',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Veuillez saisir le prénom'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _pickDateNaissance(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date de naissance',
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_dateNaissance),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _sexe,
                    decoration: const InputDecoration(labelText: 'Sexe'),
                    items: const [
                      DropdownMenuItem(
                        value: 'Masculin',
                        child: Text('Masculin'),
                      ),
                      DropdownMenuItem(
                        value: 'Féminin',
                        child: Text('Féminin'),
                      ),
                    ],
                    onChanged: (value) => setState(() => _sexe = value!),
                  ),
                  const SizedBox(height: 12),
                  anneesAsync.when(
                    data: (annees) => DropdownButtonFormField<String>(
                      value: _selectedAnneeUuid,
                      decoration: const InputDecoration(
                        labelText: 'Année scolaire',
                      ),
                      items: annees.map((annee) {
                        return DropdownMenuItem(
                          value: annee.uuid,
                          child: Text(annee.libelleAnnee),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedAnneeUuid = value),
                      validator: (value) => value == null
                          ? 'Veuillez sélectionner une année'
                          : null,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, _) => Text('Erreur année : $err'),
                  ),
                  const SizedBox(height: 12),
                  classesAsync.when(
                    data: (classes) => DropdownButtonFormField<String>(
                      value: _selectedClasseUuid,
                      decoration: const InputDecoration(labelText: 'Classe'),
                      items: classes.map((classe) {
                        // Récupérer le nom de l'option via son UUID
                        final optionName = optionsAsync.maybeWhen(
                          data: (options) {
                            final opt = options.firstWhere(
                              (opt) => opt.uuid == classe.idOptionUuid,
                              orElse: () => ScolaireOption(
                                idOption: 0,
                                uuid: '',
                                nomOption: 'Aucune option',
                                isSynced: false,
                                updatedAt: DateTime.now(),
                              ),
                            );
                            return opt.nomOption;
                          },
                          orElse: () => 'Option inconnue',
                        );
                        return DropdownMenuItem(
                          value: classe.uuid,
                          child: Text('${classe.nomClasse} ($optionName)'),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedClasseUuid = value),
                      validator: (value) => value == null
                          ? 'Veuillez sélectionner une classe'
                          : null,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                    error: (err, _) => Text('Erreur classe : $err'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _statutController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Statut'),
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
              onPressed: _saveInscription,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteInscription(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'inscription'),
        content: const Text(
          'Voulez-vous vraiment supprimer cette inscription ?',
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
      ),
    );
    if (confirm != true) return;

    try {
      final service = ref.read(inscriptionServiceProvider);
      await service.supprimerInscription(id);
      ref.refresh(inscriptionsListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription supprimée avec succès')),
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
    final inscriptionsAsync = ref.watch(inscriptionsListProvider);
    final anneesAsync = ref.watch(anneesListProvider);
    final classesAsync = ref.watch(classesListProvider);
    final optionsAsync = ref.watch(optionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscriptions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () {
              ref.refresh(inscriptionsListProvider);
              ref.refresh(anneesListProvider);
              ref.refresh(classesListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openInscriptionDialog(),
        child: const Icon(Icons.add),
        tooltip: 'Ajouter une inscription',
      ),
      body: inscriptionsAsync.when(
        data: (inscriptions) {
          if (inscriptions.isEmpty) {
            return const Center(
              child: Text(
                'Aucune inscription enregistrée. Appuyez sur + pour en ajouter.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: inscriptions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final inscription = inscriptions[index];
              // Récupérer le libellé de l'année via l'UUID
              final anneeLabel = anneesAsync.maybeWhen(
                data: (annees) {
                  final annee = annees.firstWhere(
                    (a) => a.uuid == inscription.idAnneeUuid,
                    orElse: () => AnneeScolaire(
                      idAnnee: 0,
                      uuid: '',
                      libelleAnnee: 'Année inconnue',
                      dateDebut: DateTime.now(),
                      dateFin: DateTime.now(),
                      isSynced: false,
                      updatedAt: DateTime.now(),
                    ),
                  );
                  return annee.libelleAnnee;
                },
                orElse: () => 'Chargement...',
              );
              // Récupérer la classe et son option
              final classeLabel = classesAsync.maybeWhen(
                data: (classes) {
                  final classe = classes.firstWhere(
                    (c) => c.uuid == inscription.idClasseUuid,
                    orElse: () => ClassesData(
                      idClasse: 0,
                      uuid: '',
                      nomClasse: 'Classe inconnue',
                      effectifMax: 0,
                      isSynced: false,
                      updatedAt: DateTime.now(),
                    ),
                  );
                  final optionName = optionsAsync.maybeWhen(
                    data: (options) {
                      final opt = options.firstWhere(
                        (o) => o.uuid == classe.idOptionUuid,
                        orElse: () => ScolaireOption(
                          idOption: 0,
                          uuid: '',
                          nomOption: 'Aucune option',
                          isSynced: false,
                          updatedAt: DateTime.now(),
                        ),
                      );
                      return opt.nomOption;
                    },
                    orElse: () => 'Option inconnue',
                  );
                  return '${classe.nomClasse} ($optionName)';
                },
                orElse: () => 'Chargement...',
              );

              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    '${inscription.nomEleve} ${inscription.prenomEleve}',
                  ),
                  subtitle: Text(
                    'Naissance : ${DateFormat('dd/MM/yyyy').format(inscription.dateNaissance)}\n'
                    'Sexe : ${inscription.sexe}\n'
                    'Année : $anneeLabel\n'
                    'Classe : $classeLabel\n'
                    'Statut : ${inscription.statutInscription}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Modifier',
                        onPressed: () => _openInscriptionDialog(inscription),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Supprimer',
                        onPressed: () =>
                            _deleteInscription(inscription.idInscription),
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
          child: Text('Impossible de charger les inscriptions : $error'),
        ),
      ),
    );
  }
}
