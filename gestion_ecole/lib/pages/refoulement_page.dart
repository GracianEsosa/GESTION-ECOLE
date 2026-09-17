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
import '../providers/paiement_provider.dart';
import '../providers/tarif_frais_provider.dart';
import '../providers/type_frais_provider.dart';

class RefoulementPage extends ConsumerStatefulWidget {
  const RefoulementPage({super.key});

  @override
  ConsumerState<RefoulementPage> createState() => _RefoulementPageState();
}

class _RefoulementPageState extends ConsumerState<RefoulementPage> {
  final _montantController = TextEditingController();
  String? _selectedAnneeUuid;
  String? _selectedTypeUuid;
  bool _hasSearched = false;

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final annees = ref.watch(anneesListProvider);
    final types = ref.watch(typesFraisListProvider);
    final inscriptions = ref.watch(inscriptionsListProvider);
    final classes = ref.watch(classesListProvider);
    final tarifs = ref.watch(tarifsFraisListProvider);
    final paiements = ref.watch(paiementsListProvider);

    final isLoading = annees.isLoading || types.isLoading || inscriptions.isLoading ||
        classes.isLoading || tarifs.isLoading || paiements.isLoading;
    final montantAtteint = double.tryParse(
      _montantController.text.trim().replaceAll(',', '.'),
    );
    final rows = _buildRows(
      inscriptions: inscriptions.asData?.value ?? [],
      classes: classes.asData?.value ?? [],
      tarifs: tarifs.asData?.value ?? [],
      paiements: paiements.asData?.value ?? [],
      montantAtteint: montantAtteint,
    );
    final total = rows.fold<double>(0, (sum, row) => sum + row.montantPaye);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapport de refoulement')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Élèves ayant atteint un montant',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choisissez une année, un type de frais et le montant minimum atteint. '
                    'Le cumul des paiements de chaque élève est ensuite calculé.',
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<String>(
                          value: _selectedAnneeUuid,
                          decoration: const InputDecoration(
                            labelText: 'Année scolaire',
                            border: OutlineInputBorder(),
                          ),
                          items: (annees.asData?.value ?? []).map((annee) =>
                              DropdownMenuItem(
                                value: annee.uuid,
                                child: Text(annee.libelleAnnee),
                              )).toList(),
                          onChanged: (value) => setState(() => _selectedAnneeUuid = value),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<String>(
                          value: _selectedTypeUuid,
                          decoration: const InputDecoration(
                            labelText: 'Type de frais',
                            border: OutlineInputBorder(),
                          ),
                          items: (types.asData?.value ?? []).map((type) =>
                              DropdownMenuItem(
                                value: type.uuid,
                                child: Text('${type.libelle} (${type.periodicite})'),
                              )).toList(),
                          onChanged: (value) => setState(() => _selectedTypeUuid = value),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _montantController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            labelText: 'Montant atteint minimum',
                            prefixText: 'FCFA ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          if (_selectedAnneeUuid == null ||
                              _selectedTypeUuid == null ||
                              montantAtteint == null ||
                              montantAtteint < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sélectionnez l’année, le type de frais et un montant valide.'),
                              ),
                            );
                            return;
                          }
                          setState(() => _hasSearched = true);
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Afficher'),
                      ),
                    ],
                  ),
                  if (_hasSearched) ...[
                    const SizedBox(height: 24),
                    Text(
                      '${rows.length} élève(s) trouvé(s) • Cumul : ${total.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: rows.isEmpty
                          ? null
                          : () => _previewPdf(
                              rows,
                              annees.asData!.value,
                              types.asData!.value,
                              montantAtteint!,
                            ),
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Voir le rapport PDF / Imprimer'),
                    ),
                    const SizedBox(height: 10),
                    if (rows.isEmpty)
                      const Text('Aucun élève n’a atteint ce montant pour les critères choisis.')
                    else
                      Card(
                        child: Column(
                          children: rows.map((row) => ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(row.eleve),
                            subtitle: Text('Classe : ${row.classe}'),
                            trailing: Text(
                              '${row.montantPaye.toStringAsFixed(0)} FCFA',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          )).toList(),
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }

  List<_RefoulementRow> _buildRows({
    required List<EleveInscription> inscriptions,
    required List<ClassesData> classes,
    required List<TarifsFrai> tarifs,
    required List<PaiementInscription> paiements,
    required double? montantAtteint,
  }) {
    if (!_hasSearched || _selectedAnneeUuid == null || _selectedTypeUuid == null || montantAtteint == null) {
      return [];
    }
    return inscriptions
        .where((inscription) => inscription.idAnneeUuid == _selectedAnneeUuid)
        .map((inscription) {
          final tarifUuids = tarifs
              .where((tarif) =>
                  tarif.idAnneeUuid == _selectedAnneeUuid &&
                  tarif.idTypeFraisUuid == _selectedTypeUuid &&
                  (tarif.idClasseUuid == inscription.idClasseUuid || tarif.idClasseUuid == null))
              .map((tarif) => tarif.uuid)
              .toSet();
          final cumul = paiements
              .where((paiement) =>
                  paiement.idInscriptionUuid == inscription.uuid &&
                  tarifUuids.contains(paiement.idTarifFraisUuid))
              .fold<double>(0, (sum, paiement) => sum + paiement.montantPaye);
          final matchingClasses = classes.where((classe) => classe.uuid == inscription.idClasseUuid);
          return _RefoulementRow(
            eleve: '${inscription.nomEleve} ${inscription.prenomEleve}',
            classe: matchingClasses.isEmpty ? 'Classe inconnue' : matchingClasses.first.nomClasse,
            montantPaye: cumul,
          );
        })
        .where((row) => row.montantPaye >= montantAtteint)
        .toList()
      ..sort((a, b) => b.montantPaye.compareTo(a.montantPaye));
  }

  Future<void> _previewPdf(
    List<_RefoulementRow> rows,
    List<AnneeScolaire> annees,
    List<TypesFrai> types,
    double montantAtteint,
  ) async {
    final ecole = await ref.read(ecoleProvider.future);
    final nomEcole = ecole?.nom ?? 'ECOLE GESTION SCOLAIRE';
    final annee = annees.where((item) => item.uuid == _selectedAnneeUuid).first;
    final type = types.where((item) => item.uuid == _selectedTypeUuid).first;
    final document = pw.Document();
    final total = rows.fold<double>(0, (sum, row) => sum + row.montantPaye);
    document.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (_) => [
        pw.Text('RAPPORT DE REFOULEMENT', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Text(nomEcole, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('Année scolaire : ${annee.libelleAnnee}'),
        pw.Text('Type de frais : ${type.libelle} (${type.periodicite})'),
        pw.Text('Montant minimum atteint : ${montantAtteint.toStringAsFixed(0)} FCFA'),
        pw.Text('Généré le : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
        pw.SizedBox(height: 16),
        pw.TableHelper.fromTextArray(
          headers: const ['N°', 'Élève', 'Classe', 'Cumul payé'],
          data: List.generate(rows.length, (index) => [
            '${index + 1}', rows[index].eleve, rows[index].classe,
            '${rows[index].montantPaye.toStringAsFixed(0)} FCFA',
          ]),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
        ),
        pw.SizedBox(height: 14),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Total cumulé : ${total.toStringAsFixed(0)} FCFA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
      ],
    ));
    if (!mounted) return;
    await Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Aperçu du rapport PDF')),
        body: PdfPreview(
          build: (_) => document.save(),
          pdfFileName: 'rapport_refoulement.pdf',
          canChangePageFormat: false,
          canChangeOrientation: false,
        ),
      ),
    ));
  }
}

class _RefoulementRow {
  const _RefoulementRow({
    required this.eleve,
    required this.classe,
    required this.montantPaye,
  });

  final String eleve;
  final String classe;
  final double montantPaye;
}
