import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;

import '../database/app_database.dart';
import '../providers/inscription_provider.dart';
import '../providers/paiement_provider.dart';

class PaiementPage extends ConsumerStatefulWidget {
  const PaiementPage({super.key});

  @override
  ConsumerState<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends ConsumerState<PaiementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _modeController = TextEditingController();
  final TextEditingController _motifController = TextEditingController();
  DateTime _datePaiement = DateTime.now();
  String? _selectedInscriptionUuid;
  PaiementInscription? _editingPaiement;
  DateTime _editingDatePaiement = DateTime.now();
  static const List<String> paymentModes = ['cash', 'credit', 'cheque'];

  @override
  void dispose() {
    _montantController.dispose();
    _modeController.dispose();
    _motifController.dispose();
    super.dispose();
  }

  Future<void> _pickDatePaiement(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _datePaiement,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      setState(() {
        _datePaiement = selected;
        _editingDatePaiement = selected;
      });
    }
  }

  Future<void> _savePaiement() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ref.read(paiementServiceProvider);
    final montant = double.tryParse(_montantController.text.trim()) ?? 0.0;
    final mode = _modeController.text.trim();
    final motif = _motifController.text.trim();

    try {
      if (_editingPaiement == null) {
        await service.ajouterPaiement(
          PaiementInscriptionsCompanion(
            idInscriptionUuid: drift.Value(_selectedInscriptionUuid!),
            montantPaye: drift.Value(montant),
            datePaiement: drift.Value(_datePaiement),
            modePaiement: drift.Value(mode),
            motifPaiement: drift.Value(motif),
          ),
        );
        await _setInscriptionStatutInscrit(_selectedInscriptionUuid!);
      } else {
        await service.modifierPaiement(
          _editingPaiement!.copyWith(
            idInscriptionUuid: _selectedInscriptionUuid!,
            montantPaye: montant,
            datePaiement: _editingDatePaiement,
            modePaiement: mode,
            motifPaiement: motif,
          ),
        );
        await _setInscriptionStatutInscrit(_selectedInscriptionUuid!);
      }

      ref.refresh(paiementsListProvider);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingPaiement == null
                  ? 'Paiement ajouté avec succès'
                  : 'Paiement mis à jour avec succès',
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

  Future<void> _setInscriptionStatutInscrit(String inscriptionUuid) async {
    final inscriptions = await ref.read(inscriptionsListProvider.future);
    final inscription = inscriptions.firstWhere(
      (item) => item.uuid == inscriptionUuid,
      orElse: () => throw StateError('Inscription introuvable'),
    );

    if (inscription.statutInscription != 'Inscrit') {
      final service = ref.read(inscriptionServiceProvider);
      await service.modifierInscription(
        inscription.copyWith(statutInscription: 'Inscrit'),
      );
    }
  }

  void _openPaiementDialog([PaiementInscription? paiement]) {
    if (paiement != null) {
      _editingPaiement = paiement;
      _selectedInscriptionUuid = paiement.idInscriptionUuid;
      _montantController.text = paiement.montantPaye.toString();
      _modeController.text = paiement.modePaiement;
      _motifController.text = paiement.motifPaiement;
      _datePaiement = paiement.datePaiement;
      _editingDatePaiement = paiement.datePaiement;
    } else {
      _editingPaiement = null;
      _selectedInscriptionUuid = null;
      _montantController.clear();
      _modeController.clear();
      _motifController.clear();
      _datePaiement = DateTime.now();
      _editingDatePaiement = DateTime.now();
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        final inscriptionsAsync = ref.watch(inscriptionsListProvider);

        return AlertDialog(
          title: Text(
            _editingPaiement == null
                ? 'Ajouter un paiement'
                : 'Modifier le paiement',
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  inscriptionsAsync.when(
                    data: (inscriptions) {
                      return DropdownButtonFormField<String>(
                        value: _selectedInscriptionUuid,
                        decoration: const InputDecoration(
                          labelText: 'Inscription',
                        ),
                        items: inscriptions
                            .map(
                              (item) => DropdownMenuItem(
                                value: item.uuid,
                                child: Text(
                                  '${item.nomEleve} ${item.prenomEleve}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedInscriptionUuid = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner une inscription';
                          }
                          return null;
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Text('Erreur : $error'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _montantController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Montant payé',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez saisir un montant';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Veuillez saisir un montant valide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _pickDatePaiement(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date du paiement',
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_datePaiement),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _modeController.text.isEmpty
                        ? null
                        : _modeController.text,
                    decoration: const InputDecoration(
                      labelText: 'Mode de paiement',
                    ),
                    items: paymentModes
                        .map(
                          (mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(
                              mode[0].toUpperCase() + mode.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _modeController.text = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Veuillez sélectionner un mode de paiement';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _motifController,
                    decoration: const InputDecoration(labelText: 'Motif'),
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
              onPressed: _savePaiement,
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePaiement(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le paiement'),
          content: const Text('Voulez-vous vraiment supprimer ce paiement ?'),
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
      final service = ref.read(paiementServiceProvider);
      await service.supprimerPaiement(id);
      ref.refresh(paiementsListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paiement supprimé avec succès')),
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
    final paiementsAsync = ref.watch(paiementsListProvider);
    final inscriptionsAsync = ref.watch(inscriptionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Rafraîchir',
            onPressed: () {
              ref.refresh(paiementsListProvider);
              ref.refresh(inscriptionsListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPaiementDialog(),
        tooltip: 'Ajouter un paiement',
        child: const Icon(Icons.add),
      ),
      body: paiementsAsync.when(
        data: (paiements) {
          if (paiements.isEmpty) {
            return const Center(
              child: Text(
                'Aucun paiement enregistré. Appuyez sur + pour en ajouter.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: paiements.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final paiement = paiements[index];
              final inscriptionLabel = inscriptionsAsync.maybeWhen(
                data: (inscriptions) {
                  final selected = inscriptions
                      .where(
                        (item) => item.uuid == paiement.idInscriptionUuid,
                      )
                      .toList();
                  return selected.isNotEmpty
                      ? '${selected.first.nomEleve} ${selected.first.prenomEleve}'
                      : 'Inscription inconnue';
                },
                orElse: () => 'Chargement...',
              );

              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(inscriptionLabel),
                  subtitle: Text(
                    'Montant : ${paiement.montantPaye.toStringAsFixed(2)}\n'
                    'Date : ${DateFormat('dd/MM/yyyy').format(paiement.datePaiement)}\n'
                    'Mode : ${paiement.modePaiement}\n'
                    'Motif : ${paiement.motifPaiement}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Modifier',
                        onPressed: () => _openPaiementDialog(paiement),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Supprimer',
                        onPressed: () => _deletePaiement(paiement.idPaiement),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Impossible de charger les paiements : $error')),
      ),
    );
  }
}
