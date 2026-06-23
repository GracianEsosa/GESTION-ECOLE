import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../providers/annee_provider.dart';
import '../providers/classe_provider.dart';
import '../providers/inscription_provider.dart';
import '../providers/option_provider.dart';
import '../providers/paiement_provider.dart';
import '../providers/sync_provider.dart'; // À créer
import '../providers/utilisateur_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anneesAsync = ref.watch(anneesListProvider);
    final classesAsync = ref.watch(classesListProvider);
    final optionsAsync = ref.watch(optionsListProvider);
    final inscriptionsAsync = ref.watch(inscriptionsListProvider);
    final paiementsAsync = ref.watch(paiementsListProvider);

    // Pour la synchronisation
    final unsyncedDataAsync = ref.watch(unsyncedDataProvider);
    final isSyncing = ref.watch(syncStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        centerTitle: true,
        actions: [
          // Bouton de synchronisation
          Consumer(
            builder: (context, ref, child) {
              final hasUnsynced = unsyncedDataAsync.when(
                data: (data) =>
                    data.annees.isNotEmpty ||
                    data.options.isNotEmpty ||
                    data.classes.isNotEmpty ||
                    data.inscriptions.isNotEmpty ||
                    data.paiements.isNotEmpty ||
                    data.utilisateurs.isNotEmpty,
                loading: () => false,
                error: (_, __) => false,
              );

              return Stack(
                children: [
                  IconButton(
                    icon: isSyncing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.sync),
                    tooltip: 'Synchroniser',
                    onPressed: isSyncing
                        ? null
                        : () async {
                            ref.read(syncStatusProvider.notifier).state = true;

                            bool success = false;

                            try {
                              success = await ref
                                  .read(syncServiceProvider)
                                  .syncToServer();

                              ref.invalidate(anneesListProvider);
                              ref.invalidate(optionsListProvider);
                              ref.invalidate(classesListProvider);
                              ref.invalidate(inscriptionsListProvider);
                              ref.invalidate(paiementsListProvider);
                              ref.invalidate(utilisateursListProvider);
                              ref.invalidate(unsyncedDataProvider);
                            } catch (e) {
                              print(e);
                            } finally {
                              ref.read(syncStatusProvider.notifier).state =
                                  false;
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Synchronisation réussie !'
                                        : 'Erreur de synchronisation',
                                  ),
                                ),
                              );
                            }
                          },
                  ),
                  if (hasUnsynced && !isSyncing)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte de résumé de synchronisation
            unsyncedDataAsync.when(
              data: (data) {
                final totalUnsynced =
                    data.annees.length +
                    data.options.length +
                    data.classes.length +
                    data.inscriptions.length +
                    data.paiements.length +
                    data.utilisateurs.length;

                if (totalUnsynced == 0) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$totalUnsynced élément(s) non synchronisé(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Appuyez sur le bouton sync pour envoyer au serveur',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth < 560
                    ? constraints.maxWidth
                    : 210.0;
                final sectionWidth = constraints.maxWidth < 620
                    ? constraints.maxWidth
                    : 540.0;

                return Column(
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _buildCountCard(
                            'Inscriptions',
                            inscriptionsAsync,
                            Icons.person_add,
                            const Color(0xFF3B5EFC),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _buildCountCard(
                            'Classes',
                            classesAsync,
                            Icons.class_,
                            const Color(0xFF00A896),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _buildCountCard(
                            'Options',
                            optionsAsync,
                            Icons.category,
                            const Color(0xFFFB8500),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _buildCountCard(
                            'Paiements',
                            paiementsAsync,
                            Icons.payments,
                            const Color(0xFF7209B7),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _buildCountCard(
                            'Années',
                            anneesAsync,
                            Icons.calendar_month,
                            const Color(0xFF219EBC),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        SizedBox(
                          width: sectionWidth,
                          child: _buildSection(
                            'Dernières inscriptions',
                            inscriptionsAsync,
                            (EleveInscription inscription) {
                              return _DashboardListTile(
                                title:
                                    '${inscription.nomEleve} ${inscription.prenomEleve}',
                                subtitle:
                                    'Classe : ${inscription.idClasseUuid.substring(0, 8)}...',
                                trailing: inscription.statutInscription,
                                isSynced: inscription.isSynced,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: sectionWidth,
                          child: _buildSection(
                            'Derniers paiements',
                            paiementsAsync,
                            (PaiementInscription paiement) {
                              return _DashboardListTile(
                                title:
                                    '${paiement.montantPaye.toStringAsFixed(2)} FCFA',
                                subtitle: 'Mode : ${paiement.modePaiement}',
                                trailing: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(paiement.datePaiement),
                                isSynced: paiement.isSynced,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: sectionWidth,
                          child: _buildSection(
                            'Classes en base',
                            classesAsync,
                            (ClassesData classe) {
                              return _DashboardListTile(
                                title: classe.nomClasse,
                                subtitle:
                                    'Effectif max : ${classe.effectifMax}',
                                trailing: classe.idOptionUuid == null
                                    ? 'Sans option'
                                    : 'Avec option',
                                isSynced: classe.isSynced,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: sectionWidth,
                          child: _buildSection(
                            'Options disponibles',
                            optionsAsync,
                            (ScolaireOption option) {
                              return _DashboardListTile(
                                title: option.nomOption,
                                subtitle:
                                    option.description ?? 'Aucune description',
                                trailing: '',
                                isSynced: option.isSynced,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: sectionWidth,
                          child: _buildSection('Années scolaires', anneesAsync, (
                            AnneeScolaire annee,
                          ) {
                            return _DashboardListTile(
                              title: annee.libelleAnnee,
                              subtitle:
                                  '${DateFormat('dd/MM/yyyy').format(annee.dateDebut)} → ${DateFormat('dd/MM/yyyy').format(annee.dateFin)}',
                              trailing: '',
                              isSynced: annee.isSynced,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCountCard<T>(
    String title,
    AsyncValue<List<T>> value,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: 210,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              value.when(
                data: (items) => Text(
                  '${items.length}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                loading: () => const SizedBox(
                  height: 32,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) =>
                    const Text('Erreur', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection<T>(
    String title,
    AsyncValue<List<T>> value,
    Widget Function(T item) itemBuilder,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            value.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Text('Aucune donnée disponible.');
                }
                final shownItems = items.take(4).toList();
                return Column(
                  children: shownItems
                      .map((item) => itemBuilder(item))
                      .toList(growable: false),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Text('Erreur : $error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isSynced;

  const _DashboardListTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isSynced = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!isSynced)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Sync',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          if (trailing.isNotEmpty)
            Text(
              trailing,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
