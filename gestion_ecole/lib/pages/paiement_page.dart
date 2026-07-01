// lib/pages/paiement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../providers/inscription_provider.dart';
import '../providers/paiement_provider.dart';
import '../providers/tarif_frais_provider.dart';
import '../providers/type_frais_provider.dart';

class PaiementPage extends ConsumerStatefulWidget {
  const PaiementPage({super.key});

  @override
  ConsumerState<PaiementPage> createState() => _PaiementPageState();
}

class _PaiementPageState extends ConsumerState<PaiementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _motifController = TextEditingController();

  // Variables d'état
  DateTime _selectedDate = DateTime.now();
  String? _selectedInscriptionUuid;
  String? _selectedTarifUuid;
  String? _selectedMode;
  PaiementInscription? _editingPaiement;

  // Modes de paiement disponibles
  static const List<String> _paymentModes = [
    'Espèces',
    'Carte',
    'Chèque',
    'Orange Money',
    'Wave',
  ];

  @override
  void dispose() {
    _montantController.dispose();
    _motifController.dispose();
    super.dispose();
  }

  // ============================================================
  //  Sélection de la date
  // ============================================================
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ============================================================
  //  Récupération des données pour les calculs et le ticket
  // ============================================================
  Future<TarifsFrai?> _getSelectedTarif() async {
    if (_selectedTarifUuid == null) return null;
    final tarifs = await ref.read(tarifsFraisListProvider.future);
    try {
      return tarifs.firstWhere((t) => t.uuid == _selectedTarifUuid);
    } catch (_) {
      return null;
    }
  }

  Future<double> _getDejaPaye() async {
    if (_selectedInscriptionUuid == null || _selectedTarifUuid == null)
      return 0.0;
    final paiements = await ref.read(paiementsListProvider.future);
    return paiements
        .where(
          (p) =>
              p.idInscriptionUuid == _selectedInscriptionUuid &&
              p.idTarifFraisUuid == _selectedTarifUuid,
        )
        .fold<double>(0.0, (sum, p) => sum + p.montantPaye);
  }

  Future<EleveInscription?> _getInscription(String uuid) async {
    final inscriptions = await ref.read(inscriptionsListProvider.future);
    try {
      return inscriptions.firstWhere((i) => i.uuid == uuid);
    } catch (_) {
      return null;
    }
  }

  Future<TypesFrai?> _getTypeFrais(String uuid) async {
    final types = await ref.read(typesFraisListProvider.future);
    try {
      return types.firstWhere((t) => t.uuid == uuid);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  //  Génération du ticket (format 80 mm, 32 caractères)
  // ============================================================
  String _genererTicket({
    required String eleve,
    required String tarif,
    required String trimestre,
    required double montant,
    required String mode,
    required String motif,
    required DateTime date,
  }) {
    final now = DateTime.now();
    final buffer = StringBuffer();

    void sep({String char = '='}) => buffer.writeln(char * 32);
    void center(String text) {
      final spaces = (32 - text.length) ~/ 2;
      buffer.writeln(' ' * (spaces < 0 ? 0 : spaces) + text);
    }

    final montantStr = '${montant.toStringAsFixed(0)} FCFA';

    sep();
    center('ECOLE GESTION SCOLAIRE');
    center('**********************');
    center('Reçu de paiement');
    sep();
    buffer.writeln('Date : ${DateFormat('dd/MM/yyyy HH:mm').format(now)}');
    buffer.writeln('Élève : $eleve');
    buffer.writeln('Tarif : $tarif');
    buffer.writeln('Trimestre : $trimestre');
    buffer.writeln('Montant : $montantStr');
    buffer.writeln('Mode : $mode');
    if (motif.isNotEmpty) buffer.writeln('Motif : $motif');
    sep(char: '-');
    buffer.writeln('Merci pour votre paiement !');
    sep();
    buffer.writeln('');
    return buffer.toString();
  }

  // ============================================================
  //  Affichage du ticket
  // ============================================================
  void _showTicketDialog({
    required String eleve,
    required String tarif,
    required String trimestre,
    required double montant,
    required String mode,
    required String motif,
    required DateTime date,
  }) {
    final ticketText = _genererTicket(
      eleve: eleve,
      tarif: tarif,
      trimestre: trimestre,
      montant: montant,
      mode: mode,
      motif: motif,
      date: date,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ticket de paiement'),
          content: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                ticketText,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO : Connecter une imprimante thermique
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Impression en développement...'),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text('Imprimer'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  //  Mise à jour du statut de l'inscription vers "Inscrit"
  // ============================================================
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

  // ============================================================
  //  Sauvegarde du paiement
  // ============================================================
  Future<void> _savePaiement() async {
    if (!_formKey.currentState!.validate()) return;

    final montant = double.tryParse(_montantController.text.trim()) ?? 0.0;
    final motif = _motifController.text.trim();

    // Vérification du restant dû
    final tarif = await _getSelectedTarif();
    if (tarif == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tarif introuvable')));
      return;
    }

    final dejaPaye = await _getDejaPaye();
    final restant = tarif.montant - dejaPaye;

    if (montant > restant) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Le montant ne peut pas dépasser le restant dû (FCFA ${restant.toStringAsFixed(0)})',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final service = ref.read(paiementServiceProvider);

    try {
      if (_editingPaiement == null) {
        await service.ajouterPaiement(
          idInscriptionUuid: _selectedInscriptionUuid!,
          idTarifFraisUuid: _selectedTarifUuid!,
          montantPaye: montant,
          datePaiement: _selectedDate,
          modePaiement: _selectedMode!,
          motifPaiement: motif,
        );
        await _setInscriptionStatutInscrit(_selectedInscriptionUuid!);
      } else {
        final updated = _editingPaiement!.copyWith(
          idInscriptionUuid: _selectedInscriptionUuid!,
          idTarifFraisUuid: _selectedTarifUuid!,
          montantPaye: montant,
          datePaiement: _selectedDate,
          modePaiement: _selectedMode!,
          motifPaiement: motif,
        );
        await service.modifierPaiement(updated);
        await _setInscriptionStatutInscrit(_selectedInscriptionUuid!);
      }

      ref.refresh(paiementsListProvider);

      // Afficher le ticket de paiement
      final inscription = await _getInscription(_selectedInscriptionUuid!);
      final type = await _getTypeFrais(tarif.idTypeFraisUuid);

      if (inscription != null && type != null && mounted) {
        _showTicketDialog(
          eleve: '${inscription.nomEleve} ${inscription.prenomEleve}',
          tarif: type.libelle,
          trimestre: 'T${tarif.trimestre}',
          montant: montant,
          mode: _selectedMode!,
          motif: motif,
          date: _selectedDate,
        );
      }

      // Fermer le dialogue de saisie
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

  // ============================================================
  //  Dialogue d'ajout / modification
  // ============================================================
  void _openPaiementDialog([PaiementInscription? paiement]) {
    if (paiement != null) {
      _editingPaiement = paiement;
      _selectedInscriptionUuid = paiement.idInscriptionUuid;
      _selectedTarifUuid = paiement.idTarifFraisUuid;
      _selectedMode = paiement.modePaiement;
      _montantController.text = paiement.montantPaye.toString();
      _motifController.text = paiement.motifPaiement;
      _selectedDate = paiement.datePaiement;
    } else {
      _editingPaiement = null;
      _selectedInscriptionUuid = null;
      _selectedTarifUuid = null;
      _selectedMode = null;
      _montantController.clear();
      _motifController.clear();
      _selectedDate = DateTime.now();
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        final inscriptionsAsync = ref.watch(inscriptionsListProvider);
        final tarifsAsync = ref.watch(tarifsFraisListProvider);
        final typesAsync = ref.watch(typesFraisListProvider);

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // État local pour le calcul du restant dû
            double _dejaPaye = 0.0;
            double _montantTarif = 0.0;
            bool _isLoading = false;

            Future<void> _refreshCalculs() async {
              if (_selectedTarifUuid == null ||
                  _selectedInscriptionUuid == null) {
                setStateDialog(() {
                  _dejaPaye = 0.0;
                  _montantTarif = 0.0;
                });
                return;
              }
              setStateDialog(() => _isLoading = true);
              try {
                final tarif = await _getSelectedTarif();
                final dejaPaye = await _getDejaPaye();
                setStateDialog(() {
                  _montantTarif = tarif?.montant ?? 0.0;
                  _dejaPaye = dejaPaye;
                  _isLoading = false;
                });
              } catch (e) {
                setStateDialog(() => _isLoading = false);
              }
            }

            // Charger au démarrage du dialogue
            if (_editingPaiement != null || _selectedTarifUuid != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!_isLoading) {
                  _refreshCalculs();
                }
              });
            }

            final restant = _montantTarif - _dejaPaye;

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
                      // 1. Inscription
                      inscriptionsAsync.when(
                        data: (inscriptions) {
                          return DropdownButtonFormField<String>(
                            value: _selectedInscriptionUuid,
                            decoration: const InputDecoration(
                              labelText: 'Inscription (élève)',
                            ),
                            items: inscriptions.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.uuid,
                                child: Text(
                                  '${item.nomEleve} ${item.prenomEleve}',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedInscriptionUuid = value;
                                _selectedTarifUuid = null;
                              });
                              setStateDialog(() {
                                _dejaPaye = 0.0;
                                _montantTarif = 0.0;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
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

                      // 2. Tarif (filtré)
                      if (_selectedInscriptionUuid != null)
                        Consumer(
                          builder: (context, ref, child) {
                            final inscriptions = ref
                                .watch(inscriptionsListProvider)
                                .maybeWhen(
                                  data: (data) => data,
                                  orElse: () => [],
                                );
                            final inscription = inscriptions.firstWhere(
                              (i) => i.uuid == _selectedInscriptionUuid,
                              orElse: () =>
                                  throw Exception('Inscription non trouvée'),
                            );

                            final tarifs = ref
                                .watch(tarifsFraisListProvider)
                                .maybeWhen(
                                  data: (data) => data,
                                  orElse: () => [],
                                );

                            final filteredTarifs = tarifs
                                .where(
                                  (t) =>
                                      t.idAnneeUuid ==
                                          inscription.idAnneeUuid &&
                                      t.idClasseUuid ==
                                          inscription.idClasseUuid,
                                )
                                .toList();

                            if (filteredTarifs.isEmpty) {
                              return const Text(
                                'Aucun tarif disponible pour cet élève',
                                style: TextStyle(color: Colors.red),
                              );
                            }

                            final types = ref
                                .watch(typesFraisListProvider)
                                .maybeWhen(
                                  data: (data) => data,
                                  orElse: () => [],
                                );

                            return DropdownButtonFormField<String>(
                              value: _selectedTarifUuid,
                              decoration: const InputDecoration(
                                labelText: 'Tarif (type de frais - trimestre)',
                              ),
                              items: filteredTarifs.map((tarif) {
                                final type = types.firstWhere(
                                  (t) => t.uuid == tarif.idTypeFraisUuid,
                                  orElse: () =>
                                      throw Exception('Type non trouvé'),
                                );
                                final trimestreLabel = 'T${tarif.trimestre}';
                                return DropdownMenuItem<String>(
                                  value: tarif.uuid,
                                  child: Text(
                                    '${type.code} - ${type.libelle} ($trimestreLabel) : ${tarif.montant.toStringAsFixed(0)} FCFA',
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTarifUuid = value;
                                });
                                _refreshCalculs();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez sélectionner un tarif';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                      // 3. Affichage des montants (déjà payé, restant dû)
                      if (_selectedTarifUuid != null) ...[
                        const SizedBox(height: 8),
                        if (_isLoading)
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Chargement des informations...'),
                            ],
                          )
                        else ...[
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Déjà payé :'),
                                    Text(
                                      '${_dejaPaye.toStringAsFixed(0)} FCFA',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Montant du tarif :'),
                                    Text(
                                      '${_montantTarif.toStringAsFixed(0)} FCFA',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Restant dû :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${restant.toStringAsFixed(0)} FCFA',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: restant > 0
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],

                      // 4. Montant
                      TextFormField(
                        controller: _montantController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Montant payé',
                          prefixText: 'FCFA ',
                        ),
                        onChanged: (_) {
                          // Force la validation
                          setStateDialog(() {});
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez saisir un montant';
                          }
                          final montant = double.tryParse(value.trim());
                          if (montant == null) {
                            return 'Veuillez saisir un nombre valide';
                          }
                          if (_selectedTarifUuid != null &&
                              restant > 0 &&
                              montant > restant) {
                            return 'Le montant ne peut pas dépasser le restant dû (FCFA ${restant.toStringAsFixed(0)})';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // 5. Date
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date du paiement',
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 6. Mode de paiement
                      DropdownButtonFormField<String>(
                        value: _selectedMode,
                        decoration: const InputDecoration(
                          labelText: 'Mode de paiement',
                        ),
                        items: _paymentModes.map((mode) {
                          return DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMode = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez sélectionner un mode de paiement';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // 7. Motif (optionnel)
                      TextFormField(
                        controller: _motifController,
                        decoration: const InputDecoration(
                          labelText: 'Motif (optionnel)',
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
                  onPressed: _savePaiement,
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  //  Suppression d'un paiement
  // ============================================================
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

  // ============================================================
  //  Build
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final paiementsAsync = ref.watch(paiementsListProvider);
    final inscriptionsAsync = ref.watch(inscriptionsListProvider);
    final tarifsAsync = ref.watch(tarifsFraisListProvider);
    final typesAsync = ref.watch(typesFraisListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(paiementsListProvider);
              ref.refresh(inscriptionsListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPaiementDialog(),
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
                      .where((item) => item.uuid == paiement.idInscriptionUuid)
                      .toList();
                  return selected.isNotEmpty
                      ? '${selected.first.nomEleve} ${selected.first.prenomEleve}'
                      : 'Inscription inconnue';
                },
                orElse: () => 'Chargement...',
              );

              final tarif = tarifsAsync.maybeWhen(
                data: (data) => data.firstWhere(
                  (t) => t.uuid == paiement.idTarifFraisUuid,
                  orElse: () => throw Exception('Tarif non trouvé'),
                ),
                orElse: () => null,
              );

              String tarifLabel = 'Tarif inconnu';
              if (tarif != null) {
                final type = typesAsync.maybeWhen(
                  data: (data) => data.firstWhere(
                    (t) => t.uuid == tarif.idTypeFraisUuid,
                    orElse: () => throw Exception('Type non trouvé'),
                  ),
                  orElse: () => null,
                );
                if (type != null) {
                  tarifLabel =
                      '${type.code} - ${type.libelle} (T${tarif.trimestre})';
                } else {
                  tarifLabel = 'Type inconnu (T${tarif.trimestre})';
                }
              }

              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(inscriptionLabel),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tarif : $tarifLabel'),
                      Text(
                        'Montant : ${paiement.montantPaye.toStringAsFixed(0)} FCFA',
                      ),
                      Text(
                        'Date : ${DateFormat('dd/MM/yyyy').format(paiement.datePaiement)}',
                      ),
                      Text('Mode : ${paiement.modePaiement}'),
                      if (paiement.motifPaiement.isNotEmpty)
                        Text('Motif : ${paiement.motifPaiement}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openPaiementDialog(paiement),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
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
