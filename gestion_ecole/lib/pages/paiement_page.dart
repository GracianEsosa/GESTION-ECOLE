// lib/pages/paiement_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../database/app_database.dart';
import '../providers/annee_provider.dart';
import '../providers/classe_provider.dart';
import '../providers/ecole_provider.dart';
import '../providers/inscription_provider.dart';
import '../providers/option_provider.dart';
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
  String? _selectedOptionUuid;
  String? _selectedClasseUuid;
  String? _selectedTarifUuid;
  String? _selectedMode;
  PaiementInscription? _editingPaiement;
  double _dejaPaye = 0.0;
  double _montantTarif = 0.0;
  bool _isLoading = false;
  String? _blockingMessage;

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
    if (_selectedInscriptionUuid == null || _selectedTarifUuid == null) {
      return 0.0;
    }
    final paiements = await ref.read(paiementsListProvider.future);
    return paiements
        .where(
          (p) =>
              p.idInscriptionUuid == _selectedInscriptionUuid &&
              p.idTarifFraisUuid == _selectedTarifUuid &&
              (_editingPaiement == null ||
                  p.idPaiement != _editingPaiement!.idPaiement),
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
    buffer.writeln('Date : ${DateFormat('dd/MM/yyyy HH:mm').format(date)}');
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

  Future<void> _printReceipt({
    required String eleve,
    required String tarif,
    required String trimestre,
    required double montant,
    required String mode,
    required String motif,
    required DateTime date,
  }) async {
    final ecole = await ref.read(ecoleProvider.future);
    final nomEcole = ecole?.nom ?? 'ECOLE GESTION SCOLAIRE';
    final document = pw.Document();
    final amount = '${montant.toStringAsFixed(0)} FCFA';
    final pageFormat = PdfPageFormat(
      80 * PdfPageFormat.mm,
      200 * PdfPageFormat.mm,
      marginAll: 6 * PdfPageFormat.mm,
    );

    pw.Widget line(String label, String value) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text('$label : $value', style: const pw.TextStyle(fontSize: 9)),
    );

    document.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Center(
              child: pw.Text(
                nomEcole,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Center(child: pw.Text('RECU DE PAIEMENT', style: const pw.TextStyle(fontSize: 10))),
            pw.SizedBox(height: 8),
            pw.Divider(),
            line('Date', DateFormat('dd/MM/yyyy HH:mm').format(date)),
            line('Eleve', eleve),
            line('Frais', tarif),
            line('Periode', trimestre),
            line('Montant', amount),
            line('Mode', mode),
            if (motif.isNotEmpty) line('Motif', motif),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Center(child: pw.Text('Merci pour votre paiement !', style: const pw.TextStyle(fontSize: 9))),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      name: 'recu_${DateFormat('yyyyMMdd_HHmmss').format(date)}',
      format: pageFormat,
      onLayout: (_) => document.save(),
    );
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
              onPressed: () async {
                try {
                  await _printReceipt(
                    eleve: eleve,
                    tarif: tarif,
                    trimestre: trimestre,
                    montant: montant,
                    mode: mode,
                    motif: motif,
                    date: date,
                  );
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Impossible d’imprimer : $error')),
                    );
                  }
                }
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
  //  Contrôle Séquentiel Strict des Paiements (Périodes & Années)
  // ============================================================
  Future<String?> _checkSequentialPaymentBlock(
    String inscriptionUuid,
    String tarifUuid,
  ) async {
    final allTarifs = await ref.read(tarifsFraisListProvider.future);
    final allPaiements = await ref.read(paiementsListProvider.future);
    final allTypes = await ref.read(typesFraisListProvider.future);
    final allInscriptions = await ref.read(inscriptionsListProvider.future);
    final allAnnees = await ref.read(anneesListProvider.future);

    final targetTarifMatches = allTarifs.where((t) => t.uuid == tarifUuid).toList();
    if (targetTarifMatches.isEmpty) return null;
    final targetTarif = targetTarifMatches.first;

    final targetInscriptionMatches = allInscriptions.where((i) => i.uuid == inscriptionUuid).toList();
    if (targetInscriptionMatches.isEmpty) return null;
    final targetInscription = targetInscriptionMatches.first;

    final currentAnneeMatches = allAnnees.where((a) => a.uuid == targetTarif.idAnneeUuid).toList();
    if (currentAnneeMatches.isEmpty) return null;
    final currentAnnee = currentAnneeMatches.first;

    // 1. Contrôle des années scolaires antérieures pour le MÊME élève
    final sameElevePriorInscriptions = allInscriptions.where((i) {
      if (i.uuid == inscriptionUuid) return false;
      final isSameEleve =
          i.nomEleve.trim().toLowerCase() == targetInscription.nomEleve.trim().toLowerCase() &&
          i.prenomEleve.trim().toLowerCase() == targetInscription.prenomEleve.trim().toLowerCase();
      if (!isSameEleve) return false;

      final anneeMatches = allAnnees.where((a) => a.uuid == i.idAnneeUuid).toList();
      if (anneeMatches.isEmpty) return false;
      final annee = anneeMatches.first;
      return annee.dateDebut.isBefore(currentAnnee.dateDebut);
    }).toList();

    for (final priorInsc in sameElevePriorInscriptions) {
      final priorAnneeMatches = allAnnees.where((a) => a.uuid == priorInsc.idAnneeUuid).toList();
      if (priorAnneeMatches.isEmpty) continue;
      final priorAnnee = priorAnneeMatches.first;

      final priorTarifs = allTarifs.where(
        (t) => t.idAnneeUuid == priorInsc.idAnneeUuid && (t.idClasseUuid == priorInsc.idClasseUuid || t.idClasseUuid == null),
      ).toList();

      for (final pt in priorTarifs) {
        final ptPaye = allPaiements
            .where((p) => p.idInscriptionUuid == priorInsc.uuid && p.idTarifFraisUuid == pt.uuid)
            .fold<double>(0.0, (sum, p) => sum + p.montantPaye);
        final ptRestant = pt.montant - ptPaye;

        if (ptRestant > 0) {
          return 'Paiement bloqué : L\'élève a des arriérés d\'une année scolaire précédente (${priorAnnee.libelleAnnee} - Restant : FCFA ${ptRestant.toStringAsFixed(0)}). Veuillez les solder d\'abord.';
        }
      }
    }

    // 2. Contrôle des périodes antérieures (trimestres/mois) de la MÊME année scolaire
    final currentTypeMatches = allTypes.where((t) => t.uuid == targetTarif.idTypeFraisUuid).toList();
    final currentType = currentTypeMatches.isNotEmpty ? currentTypeMatches.first : null;

    final prevTarifs = allTarifs
        .where(
          (t) =>
              t.idTypeFraisUuid == targetTarif.idTypeFraisUuid &&
              t.idAnneeUuid == targetTarif.idAnneeUuid &&
              t.trimestre < targetTarif.trimestre,
        )
        .toList()
      ..sort((a, b) => a.trimestre.compareTo(b.trimestre));

    for (final prev in prevTarifs) {
      final prevPaye = allPaiements
          .where(
            (p) =>
                p.idInscriptionUuid == inscriptionUuid &&
                p.idTarifFraisUuid == prev.uuid &&
                (_editingPaiement == null || p.idPaiement != _editingPaiement!.idPaiement),
          )
          .fold<double>(0.0, (sum, p) => sum + p.montantPaye);
      final prevRestant = prev.montant - prevPaye;

      if (prevRestant > 0) {
        final periodName = currentType?.periodicite == 'trimestriel'
            ? 'Trimestre ${prev.trimestre} (T${prev.trimestre})'
            : 'Mois ${prev.trimestre}';
        final targetPeriodName = currentType?.periodicite == 'trimestriel'
            ? 'Trimestre ${targetTarif.trimestre} (T${targetTarif.trimestre})'
            : 'Mois ${targetTarif.trimestre}';

        return 'Paiement bloqué : L\'élève doit d\'abord solder $periodName (Restant : FCFA ${prevRestant.toStringAsFixed(0)}) avant de verser sur $targetPeriodName.';
      }
    }

    return null;
  }

  // ============================================================
  //  Sauvegarde du paiement
  // ============================================================
  Future<void> _savePaiement() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInscriptionUuid == null ||
        _selectedTarifUuid == null ||
        _selectedMode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez compléter les champs requis')),
      );
      return;
    }

    final montant = double.tryParse(_montantController.text.trim()) ?? 0.0;
    final motif = _motifController.text.trim();

    final tarif = await _getSelectedTarif();
    if (tarif == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tarif introuvable')));
      return;
    }

    final dejaPaye = await _getDejaPaye();
    final restant = tarif.montant - dejaPaye;

    // 🛑 VÉRIFICATION SÉQUENTIELLE STRICTE
    final blockReason = await _checkSequentialPaymentBlock(
      _selectedInscriptionUuid!,
      _selectedTarifUuid!,
    );
    if (blockReason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(blockReason),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

      ref.invalidate(paiementsListProvider);
      ref.invalidate(inscriptionsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);

      // Afficher le ticket de paiement
      final inscription = await _getInscription(_selectedInscriptionUuid!);
      final type = await _getTypeFrais(tarif.idTypeFraisUuid);

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
        if (inscription != null && type != null) {
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
  Future<void> _openPaiementDialog([PaiementInscription? paiement]) async {
    if (paiement != null) {
      _editingPaiement = paiement;
      _selectedInscriptionUuid = paiement.idInscriptionUuid;
      _selectedTarifUuid = paiement.idTarifFraisUuid;
      _selectedMode = paiement.modePaiement;
      _montantController.text = paiement.montantPaye.toString();
      _motifController.text = paiement.motifPaiement;
      _selectedDate = paiement.datePaiement;
      final inscriptions = await ref.read(inscriptionsListProvider.future);
      final matchingInscriptions = inscriptions
          .where((item) => item.uuid == paiement.idInscriptionUuid)
          .toList();
      final inscription = matchingInscriptions.isEmpty
          ? null
          : matchingInscriptions.first;
      _selectedClasseUuid = inscription?.idClasseUuid;
      if (_selectedClasseUuid != null) {
        final classes = await ref.read(classesListProvider.future);
        final matchingClasses = classes
            .where((item) => item.uuid == _selectedClasseUuid)
            .toList();
        _selectedOptionUuid = matchingClasses.isEmpty
            ? null
            : matchingClasses.first.idOptionUuid;
      }
    } else {
      _editingPaiement = null;
      _selectedInscriptionUuid = null;
      _selectedOptionUuid = null;
      _selectedClasseUuid = null;
      _selectedTarifUuid = null;
      _selectedMode = null;
      _montantController.clear();
      _motifController.clear();
      _selectedDate = DateTime.now();
    }
    _dejaPaye = 0.0;
    _montantTarif = 0.0;
    _isLoading = false;
    _blockingMessage = null;

    showDialog<void>(
      context: context,
      builder: (context) {
        final inscriptionsAsync = ref.watch(inscriptionsListProvider);
        final optionsAsync = ref.watch(optionsListProvider);
        final classesAsync = ref.watch(classesListProvider);

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // État local pour le calcul du restant dû et blocage
            Future<void> refreshCalculs() async {
              if (_selectedTarifUuid == null ||
                  _selectedInscriptionUuid == null) {
                setStateDialog(() {
                  _dejaPaye = 0.0;
                  _montantTarif = 0.0;
                  _blockingMessage = null;
                });
                return;
              }
              setStateDialog(() => _isLoading = true);
              try {
                final tarif = await _getSelectedTarif();
                final dejaPaye = await _getDejaPaye();
                final blockReason = await _checkSequentialPaymentBlock(
                  _selectedInscriptionUuid!,
                  _selectedTarifUuid!,
                );
                setStateDialog(() {
                  _montantTarif = tarif?.montant ?? 0.0;
                  _dejaPaye = dejaPaye;
                  _blockingMessage = blockReason;
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
                  refreshCalculs();
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
                      if (_blockingMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.block, color: Colors.red, size: 24),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _blockingMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      // 1. Option
                      optionsAsync.when(
                        data: (options) => DropdownButtonFormField<String>(
                          value: _selectedOptionUuid,
                          decoration: const InputDecoration(labelText: 'Option'),
                          items: options.map((option) => DropdownMenuItem<String>(
                            value: option.uuid,
                            child: Text(option.nomOption),
                          )).toList(),
                          onChanged: (value) => setStateDialog(() {
                            _selectedOptionUuid = value;
                            _selectedClasseUuid = null;
                            _selectedInscriptionUuid = null;
                            _selectedTarifUuid = null;
                          }),
                          validator: (value) => value == null
                              ? 'Veuillez sélectionner une option'
                              : null,
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stack) => Text('Erreur : $error'),
                      ),
                      const SizedBox(height: 12),

                      // 2. Classe de l'option choisie
                      if (_selectedOptionUuid != null)
                        classesAsync.when(
                          data: (classes) {
                            final filteredClasses = classes.where(
                              (classe) => classe.idOptionUuid == _selectedOptionUuid,
                            ).toList();
                            return DropdownButtonFormField<String>(
                              value: _selectedClasseUuid,
                              decoration: const InputDecoration(labelText: 'Classe'),
                              items: filteredClasses.map((classe) => DropdownMenuItem<String>(
                                value: classe.uuid,
                                child: Text(classe.nomClasse),
                              )).toList(),
                              onChanged: (value) => setStateDialog(() {
                                _selectedClasseUuid = value;
                                _selectedInscriptionUuid = null;
                                _selectedTarifUuid = null;
                              }),
                              validator: (value) => value == null
                                  ? 'Veuillez sélectionner une classe'
                                  : null,
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stack) => Text('Erreur : $error'),
                        ),
                      if (_selectedOptionUuid != null)
                        const SizedBox(height: 12),

                      // 3. Élève inscrit dans la classe choisie
                      if (_selectedClasseUuid != null)
                        inscriptionsAsync.when(
                        data: (inscriptions) {
                          return DropdownButtonFormField<String>(
                            value: _selectedInscriptionUuid,
                            decoration: const InputDecoration(
                              labelText: 'Élève inscrit',
                            ),
                            items: inscriptions
                                .where((item) =>
                                    item.idClasseUuid == _selectedClasseUuid)
                                .map((item) {
                              return DropdownMenuItem<String>(
                                value: item.uuid,
                                child: Text(
                                  '${item.nomEleve} ${item.prenomEleve}',
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                _selectedInscriptionUuid = value;
                                _selectedTarifUuid = null;
                                _dejaPaye = 0.0;
                                _montantTarif = 0.0;
                                _blockingMessage = null;
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
                                setStateDialog(() {
                                  _selectedTarifUuid = value;
                                });
                                refreshCalculs();
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
      ref.invalidate(paiementsListProvider);
      ref.invalidate(inscriptionsListProvider);
      ref.invalidate(unsyncedPaiementsProvider);
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
              ref.invalidate(paiementsListProvider);
              ref.invalidate(inscriptionsListProvider);
              ref.invalidate(tarifsFraisListProvider);
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

          final totalGeneralEncaisse = paiements.fold<double>(
            0.0,
            (sum, p) => sum + p.montantPaye,
          );

          return Column(
            children: [
              // 📊 Carte synthétique des paiements (Total encaisse)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.indigo.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total des Encaissements',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalGeneralEncaisse.toStringAsFixed(0)} FCFA',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${paiements.length} paiement${paiements.length > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 📋 Liste des reçus de paiements
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: paiements.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final paiement = paiements[index];
                    final inscriptions = inscriptionsAsync.asData?.value ?? [];
                    final matchingInscriptions = inscriptions
                        .where((item) => item.uuid == paiement.idInscriptionUuid)
                        .toList();
                    final inscriptionLabel = matchingInscriptions.isNotEmpty
                        ? '${matchingInscriptions.first.nomEleve} ${matchingInscriptions.first.prenomEleve}'
                        : 'Inscription inconnue';

                    final tarifs = tarifsAsync.asData?.value ?? [];
                    final matchingTarifs = tarifs
                        .where((t) => t.uuid == paiement.idTarifFraisUuid)
                        .toList();
                    final TarifsFrai? tarif =
                        matchingTarifs.isNotEmpty ? matchingTarifs.first : null;

                    String tarifLabel = 'Tarif inconnu';
                    TypesFrai? type;
                    if (tarif != null) {
                      final types = typesAsync.asData?.value ?? [];
                      final matchingTypes = types
                          .where((t) => t.uuid == tarif.idTypeFraisUuid)
                          .toList();
                      type = matchingTypes.isNotEmpty ? matchingTypes.first : null;

                      if (type != null) {
                        tarifLabel =
                            '${type.code} - ${type.libelle} (T${tarif.trimestre})';
                      } else {
                        tarifLabel = 'Type inconnu (T${tarif.trimestre})';
                      }
                    }

                    // Calcul dynamique du total déjà payé pour cette inscription et ce tarif
                    final cumulPayeEleve = paiements
                        .where(
                          (p) =>
                              p.idInscriptionUuid ==
                                  paiement.idInscriptionUuid &&
                              p.idTarifFraisUuid == paiement.idTarifFraisUuid,
                        )
                        .fold<double>(0.0, (sum, p) => sum + p.montantPaye);

                    final montantTarifTotal = tarif?.montant ?? 0.0;
                    final restantDu = montantTarifTotal - cumulPayeEleve;
                    final isPayeIntegralle =
                        montantTarifTotal > 0 && restantDu <= 0;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête de la carte : Nom de l'élève & mode
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    inscriptionLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    paiement.modePaiement,
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 14),

                            // Détails du tarif & montant de ce versement
                            Text(
                              'Tarif : $tarifLabel',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Montant de ce versement :',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                Text(
                                  '${paiement.montantPaye.toStringAsFixed(0)} FCFA',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // 🔥 Encadré récapitulatif : Cumul déjà payé & Restant dû
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Déjà payé (Total élève) :',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      Text(
                                        '${cumulPayeEleve.toStringAsFixed(0)} / ${montantTarifTotal.toStringAsFixed(0)} FCFA',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPayeIntegralle
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isPayeIntegralle
                                          ? 'Payé intégralement'
                                          : 'Restant : ${restantDu.toStringAsFixed(0)} FCFA',
                                      style: TextStyle(
                                        color: isPayeIntegralle
                                            ? Colors.green.shade900
                                            : Colors.orange.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Date & Motif + Actions (Modifier, Supprimer)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date : ${DateFormat('dd/MM/yyyy').format(paiement.datePaiement)}' +
                                        (paiement.motifPaiement.isNotEmpty
                                            ? ' • ${paiement.motifPaiement}'
                                            : ''),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.print,
                                        size: 20,
                                        color: Colors.deepPurple,
                                      ),
                                      onPressed: () => _printReceipt(
                                        eleve: inscriptionLabel,
                                        tarif: type?.libelle ?? tarifLabel,
                                        trimestre: tarif == null
                                            ? '-'
                                            : 'T${tarif.trimestre}',
                                        montant: paiement.montantPaye,
                                        mode: paiement.modePaiement,
                                        motif: paiement.motifPaiement,
                                        date: paiement.datePaiement,
                                      ),
                                      tooltip: 'Imprimer le reçu',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _openPaiementDialog(paiement),
                                      tooltip: 'Modifier',
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          _deletePaiement(paiement.idPaiement),
                                      tooltip: 'Supprimer',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Impossible de charger les paiements : $error')),
      ),
    );
  }
}
