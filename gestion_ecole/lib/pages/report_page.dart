import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../providers/annee_provider.dart';
import '../providers/classe_provider.dart';
import '../providers/inscription_provider.dart';
import '../providers/option_provider.dart';
import '../providers/paiement_provider.dart';
import '../providers/utilisateur_provider.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  String? _selectedClasseUuid;
  String? _selectedOptionUuid;
  DateTime _paidFrom = DateTime.now().subtract(const Duration(days: 30));
  DateTime _paidTo = DateTime.now();
  int _activeReport = 1;

  @override
  Widget build(BuildContext context) {
    final utilisateursAsync = ref.watch(utilisateursListProvider);
    final inscriptionsAsync = ref.watch(inscriptionsListProvider);
    final paiementsAsync = ref.watch(paiementsListProvider);
    final classesAsync = ref.watch(classesListProvider);
    final optionsAsync = ref.watch(optionsListProvider);
    final anneesAsync = ref.watch(anneesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapports')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 780;
          final cardWidth = isMobile ? constraints.maxWidth : 220.0;
          final contentPadding = EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: 16,
          );

          return SingleChildScrollView(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tableau de bord des rapports',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Analyse rapide des inscriptions, des paiements et des effectifs.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Utilisateurs',
                        description: 'Comptes actifs',
                        asyncValue: utilisateursAsync,
                        icon: Icons.person,
                        color: Colors.indigo,
                        valueBuilder: (items) => '${items.length}',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Inscriptions',
                        description: 'Élèves inscrits',
                        asyncValue: inscriptionsAsync,
                        icon: Icons.person_add,
                        color: Colors.green,
                        valueBuilder: (items) => '${items.length}',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Paiements',
                        description: 'Revenus collectés',
                        asyncValue: paiementsAsync,
                        icon: Icons.payments,
                        color: Colors.orange,
                        valueBuilder: (items) {
                          final total = items.fold<double>(
                            0,
                            (sum, paiement) => sum + paiement.montantPaye,
                          );
                          return '${total.toStringAsFixed(2)} FCFA';
                        },
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Classes',
                        description: 'Salles et sections',
                        asyncValue: classesAsync,
                        icon: Icons.class_,
                        color: Colors.blueGrey,
                        valueBuilder: (items) => '${items.length}',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Options',
                        description: 'Parcours disponibles',
                        asyncValue: optionsAsync,
                        icon: Icons.category,
                        color: Colors.deepPurple,
                        valueBuilder: (items) => '${items.length}',
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: _SummaryCard(
                        title: 'Années',
                        description: 'Périodes scolaires',
                        asyncValue: anneesAsync,
                        icon: Icons.calendar_month,
                        color: Colors.teal,
                        valueBuilder: (items) => '${items.length}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Élèves par classe / option'),
                        selected: _activeReport == 1,
                        onSelected: (_) => setState(() => _activeReport = 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Élèves ayant déjà payé'),
                        selected: _activeReport == 2,
                        onSelected: (_) => setState(() => _activeReport = 2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (_activeReport == 1)
                  _buildClasseOptionReport(
                    context,
                    inscriptionsAsync,
                    classesAsync,
                    optionsAsync,
                    isMobile,
                  )
                else
                  _buildPaiementsReport(
                    context,
                    inscriptionsAsync,
                    paiementsAsync,
                    classesAsync,
                    optionsAsync,
                    isMobile,
                  ),
                const SizedBox(height: 24),
                const Text(
                  'Rapports rapides',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _ReportActionButton(
                  label: 'Voir les utilisateurs',
                  icon: Icons.person,
                  onPressed: () => _showDetailReport(
                    context,
                    'Utilisateurs',
                    utilisateursAsync,
                    (item) =>
                        '${item.nomUtilisateur} ${item.postnomUtilisateur}',
                  ),
                ),
                _ReportActionButton(
                  label: 'Voir les inscriptions',
                  icon: Icons.person_add,
                  onPressed: () => _showDetailReport(
                    context,
                    'Inscriptions',
                    inscriptionsAsync,
                    (item) =>
                        '${item.nomEleve} ${item.prenomEleve} - classe ${item.idClasseUuid.substring(0, 8)}',
                  ),
                ),
                _ReportActionButton(
                  label: 'Voir les paiements',
                  icon: Icons.payments,
                  onPressed: () => _showDetailReport(
                    context,
                    'Paiements',
                    paiementsAsync,
                    (item) =>
                        '${item.montantPaye.toStringAsFixed(2)} FCFA - ${item.modePaiement}',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClasseOptionReport(
    BuildContext context,
    AsyncValue<List<EleveInscription>> inscriptionsAsync,
    AsyncValue<List<ClassesData>> classesAsync,
    AsyncValue<List<ScolaireOption>> optionsAsync,
    bool isMobile,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Élèves par classe et option',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Filtrez les élèves selon la salle et l’option pour voir les effectifs.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            classesAsync.when(
              data: (classes) => optionsAsync.when(
                data: (options) => inscriptionsAsync.when(
                  data: (inscriptions) {
                    // Filtrage par classe (UUID) et option (UUID)
                    final filtered = inscriptions.where((inscription) {
                      final classe = classes.firstWhere(
                        (c) => c.uuid == inscription.idClasseUuid,
                        orElse: () => ClassesData(
                          idClasse: -1,
                          uuid: '',
                          nomClasse: 'Classe inconnue',
                          idOptionUuid: null,
                          effectifMax: 0,
                          isSynced: false,
                          updatedAt: DateTime.now(),
                        ),
                      );
                      final matchesClasse =
                          _selectedClasseUuid == null ||
                          inscription.idClasseUuid == _selectedClasseUuid;
                      final matchesOption =
                          _selectedOptionUuid == null ||
                          classe.idOptionUuid == _selectedOptionUuid;
                      return matchesClasse && matchesOption;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.start,
                          children: [
                            SizedBox(
                              width: isMobile ? double.infinity : 260,
                              child: DropdownButtonFormField<String?>(
                                value: _selectedClasseUuid,
                                decoration: const InputDecoration(
                                  labelText: 'Classe / Salle',
                                  border: OutlineInputBorder(),
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Toutes les classes'),
                                  ),
                                  ...classes.map(
                                    (classe) => DropdownMenuItem<String?>(
                                      value: classe.uuid,
                                      child: Text(classe.nomClasse),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() => _selectedClasseUuid = value);
                                },
                              ),
                            ),
                            SizedBox(
                              width: isMobile ? double.infinity : 260,
                              child: DropdownButtonFormField<String?>(
                                value: _selectedOptionUuid,
                                decoration: const InputDecoration(
                                  labelText: 'Option',
                                  border: OutlineInputBorder(),
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Toutes les options'),
                                  ),
                                  ...options.map(
                                    (option) => DropdownMenuItem<String?>(
                                      value: option.uuid,
                                      child: Text(option.nomOption),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() => _selectedOptionUuid = value);
                                },
                              ),
                            ),
                            FilledButton(
                              onPressed: () {
                                setState(() {
                                  _selectedClasseUuid = null;
                                  _selectedOptionUuid = null;
                                });
                              },
                              child: const Text('Réinitialiser'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Élèves trouvés : ${filtered.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (filtered.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Aucun élève ne correspond aux filtres sélectionnés.',
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final inscription = filtered[index];
                              final classe = classes.firstWhere(
                                (c) => c.uuid == inscription.idClasseUuid,
                                orElse: () => ClassesData(
                                  idClasse: -1,
                                  uuid: '',
                                  nomClasse: 'Classe inconnue',
                                  idOptionUuid: null,
                                  effectifMax: 0,
                                  isSynced: false,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                              final option = classe.idOptionUuid != null
                                  ? options.firstWhere(
                                      (o) => o.uuid == classe.idOptionUuid,
                                      orElse: () => ScolaireOption(
                                        idOption: -1,
                                        uuid: '',
                                        nomOption: 'Aucune option',
                                        isSynced: false,
                                        updatedAt: DateTime.now(),
                                      ),
                                    )
                                  : ScolaireOption(
                                      idOption: -1,
                                      uuid: '',
                                      nomOption: 'Aucune option',
                                      isSynced: false,
                                      updatedAt: DateTime.now(),
                                    );

                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                                title: Text(
                                  '${inscription.nomEleve} ${inscription.prenomEleve}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  'Classe : ${classe.nomClasse} • Option : ${option.nomOption} • Statut : ${inscription.statutInscription}',
                                ),
                                trailing: Chip(
                                  label: Text(
                                    option.nomOption,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('Erreur : $error'),
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('Erreur : $error'),
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('Erreur : $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaiementsReport(
    BuildContext context,
    AsyncValue<List<EleveInscription>> inscriptionsAsync,
    AsyncValue<List<PaiementInscription>> paiementsAsync,
    AsyncValue<List<ClassesData>> classesAsync,
    AsyncValue<List<ScolaireOption>> optionsAsync,
    bool isMobile,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paiements des élèves',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Filtrez les paiements par classe, option et période pour suivre les montants reçus.',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            classesAsync.when(
              data: (classes) => optionsAsync.when(
                data: (options) => inscriptionsAsync.when(
                  data: (inscriptions) => paiementsAsync.when(
                    data: (paiements) {
                      // Associer chaque paiement à son inscription, sa classe et son option
                      final filtered = paiements
                          .map((paiement) {
                            final inscription = inscriptions.firstWhere(
                              (i) => i.uuid == paiement.idInscriptionUuid,
                              orElse: () => EleveInscription(
                                idInscription: -1,
                                uuid: '',
                                nomEleve: 'Inconnu',
                                prenomEleve: '',
                                dateNaissance: DateTime.now(),
                                sexe: '',
                                idAnneeUuid: '',
                                idClasseUuid: '',
                                dateInscription: DateTime.now(),
                                statutInscription: '',
                                isSynced: false,
                                updatedAt: DateTime.now(),
                              ),
                            );
                            if (inscription.idInscription == -1) return null;
                            final classe = classes.firstWhere(
                              (c) => c.uuid == inscription.idClasseUuid,
                              orElse: () => ClassesData(
                                idClasse: -1,
                                uuid: '',
                                nomClasse: 'Classe inconnue',
                                idOptionUuid: null,
                                effectifMax: 0,
                                isSynced: false,
                                updatedAt: DateTime.now(),
                              ),
                            );
                            final option = classe.idOptionUuid != null
                                ? options.firstWhere(
                                    (o) => o.uuid == classe.idOptionUuid,
                                    orElse: () => ScolaireOption(
                                      idOption: -1,
                                      uuid: '',
                                      nomOption: 'Aucune option',
                                      isSynced: false,
                                      updatedAt: DateTime.now(),
                                    ),
                                  )
                                : ScolaireOption(
                                    idOption: -1,
                                    uuid: '',
                                    nomOption: 'Aucune option',
                                    isSynced: false,
                                    updatedAt: DateTime.now(),
                                  );
                            return _PaiementEleveInfo(
                              inscription: inscription,
                              paiement: paiement,
                              classe: classe,
                              option: option,
                            );
                          })
                          .whereType<_PaiementEleveInfo>()
                          .where((item) {
                            final matchesDate =
                                !item.paiement.datePaiement.isBefore(
                                  _paidFrom,
                                ) &&
                                !item.paiement.datePaiement.isAfter(_paidTo);
                            final matchesClasse =
                                _selectedClasseUuid == null ||
                                item.inscription.idClasseUuid ==
                                    _selectedClasseUuid;
                            final matchesOption =
                                _selectedOptionUuid == null ||
                                item.classe.idOptionUuid == _selectedOptionUuid;
                            return matchesDate &&
                                matchesClasse &&
                                matchesOption;
                          })
                          .toList();

                      final totalMontant = filtered.fold<double>(
                        0,
                        (sum, item) => sum + item.paiement.montantPaye,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.start,
                            children: [
                              SizedBox(
                                width: isMobile ? double.infinity : 200,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Du',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        _pickPaymentDate(context, true),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(_paidFrom),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: isMobile ? double.infinity : 200,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Au',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: InkWell(
                                    onTap: () =>
                                        _pickPaymentDate(context, false),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      child: Text(
                                        DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(_paidTo),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: isMobile ? double.infinity : 260,
                                child: DropdownButtonFormField<String?>(
                                  value: _selectedClasseUuid,
                                  decoration: const InputDecoration(
                                    labelText: 'Classe',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Toutes les classes'),
                                    ),
                                    ...classes.map(
                                      (classe) => DropdownMenuItem<String?>(
                                        value: classe.uuid,
                                        child: Text(classe.nomClasse),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedClasseUuid = value);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: isMobile ? double.infinity : 260,
                                child: DropdownButtonFormField<String?>(
                                  value: _selectedOptionUuid,
                                  decoration: const InputDecoration(
                                    labelText: 'Option',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('Toutes les options'),
                                    ),
                                    ...options.map(
                                      (option) => DropdownMenuItem<String?>(
                                        value: option.uuid,
                                        child: Text(option.nomOption),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _selectedOptionUuid = value);
                                  },
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedClasseUuid = null;
                                    _selectedOptionUuid = null;
                                    _paidFrom = DateTime.now().subtract(
                                      const Duration(days: 30),
                                    );
                                    _paidTo = DateTime.now();
                                  });
                                },
                                child: const Text('Réinitialiser'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Paiements trouvés : ${filtered.length} • Total : ${totalMontant.toStringAsFixed(2)} FCFA',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Aucun paiement ne correspond aux filtres.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    '${item.inscription.nomEleve} ${item.inscription.prenomEleve}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Classe : ${item.classe.nomClasse} • Option : ${item.option.nomOption}\nMontant : ${item.paiement.montantPaye.toStringAsFixed(2)} FCFA • Mode : ${item.paiement.modePaiement}',
                                  ),
                                  trailing: Text(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(item.paiement.datePaiement),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text('Erreur : $error'),
                    ),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text('Erreur : $error'),
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text('Erreur : $error'),
                ),
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text('Erreur : $error'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPaymentDate(BuildContext context, bool isFrom) async {
    final initialDate = isFrom ? _paidFrom : _paidTo;
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        if (isFrom) {
          _paidFrom = selected;
          if (_paidFrom.isAfter(_paidTo)) {
            _paidTo = _paidFrom;
          }
        } else {
          _paidTo = selected;
          if (_paidTo.isBefore(_paidFrom)) {
            _paidFrom = _paidTo;
          }
        }
      });
    }
  }

  void _showDetailReport<T>(
    BuildContext context,
    String title,
    AsyncValue<List<T>> asyncValue,
    String Function(T item) labelBuilder,
  ) {
    asyncValue.when(
      data: (items) {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: items.isEmpty
                    ? const Text('Aucune donnée disponible.')
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          return Text(labelBuilder(items[index]));
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chargement des données...')),
        );
      },
      error: (error, stack) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $error')));
      },
    );
  }
}

class _PaiementEleveInfo {
  final EleveInscription inscription;
  final PaiementInscription paiement;
  final ClassesData classe;
  final ScolaireOption option;

  _PaiementEleveInfo({
    required this.inscription,
    required this.paiement,
    required this.classe,
    required this.option,
  });
}

class _SummaryCard<T> extends StatelessWidget {
  final String title;
  final String description;
  final AsyncValue<List<T>> asyncValue;
  final IconData icon;
  final Color color;
  final String Function(List<T>) valueBuilder;

  const _SummaryCard({
    required this.title,
    required this.description,
    required this.asyncValue,
    required this.icon,
    required this.color,
    required this.valueBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              asyncValue.when(
                data: (items) => Text(
                  valueBuilder(items),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                loading: () => const SizedBox(
                  height: 28,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) =>
                    const Text('Erreur', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ReportActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
