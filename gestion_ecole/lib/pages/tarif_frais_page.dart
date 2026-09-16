// lib/pages/tarif_frais_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/tarif_frais_provider.dart';
import '../providers/annee_provider.dart';
import '../providers/classe_provider.dart';
import '../providers/type_frais_provider.dart';

class TarifFraisPage extends ConsumerStatefulWidget {
  const TarifFraisPage({super.key});

  @override
  ConsumerState<TarifFraisPage> createState() => _TarifFraisPageState();
}

class _TarifFraisPageState extends ConsumerState<TarifFraisPage> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  String? _selectedTypeFraisUuid;
  String? _selectedAnneeUuid;
  String? _selectedClasseUuid;
  int _selectedTrimestre = 1;
  TarifsFrai? _editingTarif;

  bool _genererToutesPeriodes = true;

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _saveTarifFrais() async {
    if (!_formKey.currentState!.validate()) return;

    final service = ref.read(tarifFraisServiceProvider);
    final montant = double.parse(_montantController.text.trim());

    try {
      if (_editingTarif == null) {
        if (_genererToutesPeriodes && _selectedTypeFraisUuid != null) {
          final types = ref.read(typesFraisListProvider).asData?.value ?? [];
          final matching = types.where((t) => t.uuid == _selectedTypeFraisUuid).toList();
          final periodicite = matching.isNotEmpty ? matching.first.periodicite : 'mensuel';

          await service.meublerTarifsPourTypeFrais(
            idTypeFraisUuid: _selectedTypeFraisUuid!,
            idAnneeUuid: _selectedAnneeUuid!,
            idClasseUuid: _selectedClasseUuid,
            montant: montant,
            periodicite: periodicite,
          );
        } else {
          await service.ajouterTarif(
            _selectedTypeFraisUuid!,
            _selectedAnneeUuid!,
            _selectedClasseUuid!,
            montant,
            trimestre: _selectedTrimestre,
          );
        }
      } else {
        final modified = await service.modifierTarif(
          _editingTarif!.idTarif,
          _selectedTypeFraisUuid!,
          _selectedAnneeUuid!,
          _selectedClasseUuid!,
          montant,
          trimestre: _selectedTrimestre,
        );

        if (!modified) {
          throw Exception('Impossible de modifier le tarif.');
        }
      }

      ref.invalidate(tarifsFraisListProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingTarif == null
                  ? (_genererToutesPeriodes ? 'Tarifs de toutes les périodes générés avec succès' : 'Tarif ajouté avec succès')
                  : 'Tarif mis à jour avec succès',
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

  Future<void> _showTarifFraisDialog([TarifsFrai? tarifFrais]) async {
    if (tarifFrais != null) {
      _editingTarif = tarifFrais;
      _selectedTypeFraisUuid = tarifFrais.idTypeFraisUuid;
      _selectedAnneeUuid = tarifFrais.idAnneeUuid;
      _selectedClasseUuid = tarifFrais.idClasseUuid;
      _selectedTrimestre = tarifFrais.trimestre;
      _montantController.text = tarifFrais.montant.toString();
    } else {
      _editingTarif = null;
      _selectedTypeFraisUuid = null;
      _selectedAnneeUuid = null;
      _selectedClasseUuid = null;
      _selectedTrimestre = 1;
      _montantController.clear();
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final types = ref.watch(typesFraisListProvider).asData?.value ?? [];
            final selectedType = types.where((t) => t.uuid == _selectedTypeFraisUuid).toList();
            final periodicite = selectedType.isNotEmpty ? selectedType.first.periodicite : 'mensuel';

            return AlertDialog(
              title: Text(
                _editingTarif == null ? 'Ajouter un tarif' : 'Modifier le tarif',
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Type de frais
                      Consumer(
                        builder: (context, ref, child) {
                          final typesAsync = ref.watch(typesFraisListProvider);
                          return typesAsync.when(
                            data: (types) {
                              if (types.isEmpty) {
                                return const Text(
                                  'Aucun type de frais disponible. Veuillez en ajouter d\'abord.',
                                  style: TextStyle(color: Colors.red),
                                );
                              }
                              return DropdownButtonFormField<String>(
                                value: _selectedTypeFraisUuid,
                                decoration: const InputDecoration(
                                  labelText: 'Type de frais',
                                ),
                                items: types.map((t) {
                                  return DropdownMenuItem<String>(
                                    value: t.uuid,
                                    child: Text('${t.code} - ${t.libelle} (${t.periodicite})'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTypeFraisUuid = value;
                                  });
                                  setStateDialog(() {
                                    _selectedTrimestre = 1;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner un type de frais';
                                  }
                                  return null;
                                },
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Erreur: $e'),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Mode de génération (Tout auto ou une seule période)
                      if (_editingTarif == null && _selectedTypeFraisUuid != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                periodicite == 'trimestriel'
                                    ? 'Générer automatiquement pour les 3 trimestres'
                                    : periodicite == 'annuel' || periodicite == 'mensuel'
                                        ? 'Générer automatiquement pour les 10 mois'
                                        : 'Versement unique',
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                              ),
                            ),
                            Switch(
                              value: _genererToutesPeriodes,
                              onChanged: (val) {
                                setStateDialog(() => _genererToutesPeriodes = val);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Sélection de la Période / Trimestre
                      if (_selectedTypeFraisUuid != null && (!_genererToutesPeriodes || _editingTarif != null)) ...[
                        if (periodicite == 'trimestriel')
                          DropdownButtonFormField<int>(
                            value: _selectedTrimestre,
                            decoration: const InputDecoration(
                              labelText: 'Trimestre concerné',
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Trimestre 1 (T1)')),
                              DropdownMenuItem(value: 2, child: Text('Trimestre 2 (T2)')),
                              DropdownMenuItem(value: 3, child: Text('Trimestre 3 (T3)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setStateDialog(() => _selectedTrimestre = val);
                            },
                          )
                        else if (periodicite == 'mensuel' || periodicite == 'annuel')
                          DropdownButtonFormField<int>(
                            value: _selectedTrimestre,
                            decoration: const InputDecoration(
                              labelText: 'Mois / Tranche concernée',
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Mois 1 (Septembre)')),
                              DropdownMenuItem(value: 2, child: Text('Mois 2 (Octobre)')),
                              DropdownMenuItem(value: 3, child: Text('Mois 3 (Novembre)')),
                              DropdownMenuItem(value: 4, child: Text('Mois 4 (Décembre)')),
                              DropdownMenuItem(value: 5, child: Text('Mois 5 (Janvier)')),
                              DropdownMenuItem(value: 6, child: Text('Mois 6 (Février)')),
                              DropdownMenuItem(value: 7, child: Text('Mois 7 (Mars)')),
                              DropdownMenuItem(value: 8, child: Text('Mois 8 (Avril)')),
                              DropdownMenuItem(value: 9, child: Text('Mois 9 (Mai)')),
                              DropdownMenuItem(value: 10, child: Text('Mois 10 (Juin)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setStateDialog(() => _selectedTrimestre = val);
                            },
                          ),
                        const SizedBox(height: 12),
                      ],

                      // Année scolaire
                      Consumer(
                        builder: (context, ref, child) {
                          final anneesAsync = ref.watch(anneesListProvider);
                          return anneesAsync.when(
                            data: (annees) {
                              if (annees.isEmpty) {
                                return const Text(
                                  'Aucune année scolaire disponible.',
                                  style: TextStyle(color: Colors.red),
                                );
                              }
                              return DropdownButtonFormField<String>(
                                value: _selectedAnneeUuid,
                                decoration: const InputDecoration(
                                  labelText: 'Année scolaire',
                                ),
                                items: annees.map((a) {
                                  return DropdownMenuItem<String>(
                                    value: a.uuid,
                                    child: Text(a.libelleAnnee),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnneeUuid = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner une année';
                                  }
                                  return null;
                                },
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Erreur: $e'),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Classe (obligatoire)
                      Consumer(
                        builder: (context, ref, child) {
                          final classesAsync = ref.watch(classesListProvider);
                          return classesAsync.when(
                            data: (classes) {
                              if (classes.isEmpty) {
                                return const Text(
                                  'Aucune classe disponible.',
                                  style: TextStyle(color: Colors.red),
                                );
                              }
                              return DropdownButtonFormField<String>(
                                value: _selectedClasseUuid,
                                decoration: const InputDecoration(
                                  labelText: 'Classe (obligatoire)',
                                ),
                                items: classes.map((c) {
                                  return DropdownMenuItem<String>(
                                    value: c.uuid,
                                    child: Text(c.nomClasse),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedClasseUuid = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner une classe';
                                  }
                                  return null;
                                },
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (e, _) => Text('Erreur: $e'),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Montant
                      TextFormField(
                        controller: _montantController,
                        decoration: const InputDecoration(
                          labelText: 'Montant du tarif',
                          hintText: 'Ex. 15000',
                          prefixText: 'FCFA ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Veuillez saisir un montant';
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return 'Veuillez saisir un nombre valide';
                          }
                          return null;
                        },
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
                  onPressed: _saveTarifFrais,
                  child: const Text('Enregistrer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTarifFrais(int idTarif) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer le tarif'),
          content: const Text('Voulez-vous vraiment supprimer ce tarif ?'),
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
      final service = ref.read(tarifFraisServiceProvider);
      await service.supprimerTarif(idTarif);
      ref.refresh(tarifsFraisListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarif supprimé avec succès')),
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

  String _getTypeFraisLibelle(String uuid) {
    final types = ref
        .read(typesFraisListProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);
    final type = types.firstWhere(
      (t) => t.uuid == uuid,
      orElse: () => throw Exception('Type non trouvé'),
    );
    return '${type.code} - ${type.libelle}';
  }

  String _getAnneeLibelle(String uuid) {
    final annees = ref
        .read(anneesListProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);
    final annee = annees.firstWhere(
      (a) => a.uuid == uuid,
      orElse: () => throw Exception('Année non trouvée'),
    );
    return annee.libelleAnnee;
  }

  String _getClasseLibelle(String? uuid) {
    if (uuid == null) return 'Classe inconnue';
    final classes = ref
        .read(classesListProvider)
        .maybeWhen(data: (data) => data, orElse: () => []);
    final classe = classes.firstWhere(
      (c) => c.uuid == uuid,
      orElse: () => throw Exception('Classe non trouvée'),
    );
    return classe.nomClasse;
  }

  String _getPeriodText(TarifsFrai tarif) {
    final types = ref.read(typesFraisListProvider).asData?.value ?? [];
    final matching = types.where((t) => t.uuid == tarif.idTypeFraisUuid).toList();
    if (matching.isEmpty) return 'Période : T${tarif.trimestre}';
    final periodicite = matching.first.periodicite;

    if (periodicite == 'trimestriel') {
      return 'Période : Trimestre ${tarif.trimestre} (T${tarif.trimestre})';
    } else if (periodicite == 'mensuel' || periodicite == 'annuel') {
      final moisNames = [
        'Septembre', 'Octobre', 'Novembre', 'Décembre', 'Janvier',
        'Février', 'Mars', 'Avril', 'Mai', 'Juin'
      ];
      final moisLabel = (tarif.trimestre >= 1 && tarif.trimestre <= moisNames.length)
          ? moisNames[tarif.trimestre - 1]
          : '${tarif.trimestre}';
      return 'Période : Mois ${tarif.trimestre} ($moisLabel)';
    } else {
      return 'Période : Versement Unique';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tarifsAsync = ref.watch(tarifsFraisListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifs des frais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              ref.invalidate(tarifsFraisListProvider);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTarifFraisDialog(),
        tooltip: 'Ajouter un tarif',
        child: const Icon(Icons.add),
      ),
      body: tarifsAsync.when(
        data: (tarifs) {
          if (tarifs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_money, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun tarif de frais.', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'Cliquez sur + pour ajouter un tarif.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tarifs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tarif = tarifs[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    '${_getTypeFraisLibelle(tarif.idTypeFraisUuid)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_getPeriodText(tarif), style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w500)),
                      Text('Année: ${_getAnneeLibelle(tarif.idAnneeUuid)}'),
                      Text('Classe: ${_getClasseLibelle(tarif.idClasseUuid)}'),
                      Text(
                        'Montant: FCFA ${tarif.montant.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        onPressed: () => _showTarifFraisDialog(tarif),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () => _deleteTarifFrais(tarif.idTarif),
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
            Center(child: Text('Impossible de charger les tarifs : $error')),
      ),
    );
  }
}
