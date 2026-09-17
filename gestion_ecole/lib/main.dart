import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;

import 'pages/dashboard_page.dart';
import 'pages/report_page.dart';
import 'pages/inscription_page.dart';
import 'pages/login_page.dart';
import 'pages/utilisateur_page.dart';
import 'pages/classe_page.dart';
import 'pages/option_page.dart';
import 'pages/paiement_page.dart';
import 'pages/annee_page.dart';
import 'pages/refoulement_page.dart';
import 'pages/ecole_page.dart';

// 🆕 Import des nouvelles pages (sans factures)
import 'pages/type_frais_page.dart';
import 'pages/tarif_frais_page.dart';
// import 'pages/facture_list_page.dart';  // ❌ Supprimé

import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null); // Initialiser les locales
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion de l\'école',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const LoginPage(),
      routes: {'/home': (_) => const HomePage()},
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // Menu sans "Factures"
  final List<Map<String, dynamic>> menuItems = const [
    {'label': 'École', 'icon': Icons.school},
    {'label': 'Dashboard', 'icon': Icons.dashboard},
    {'label': 'Rapports', 'icon': Icons.bar_chart},
    {'label': 'Inscriptions', 'icon': Icons.person_add},
    {'label': 'Utilisateurs', 'icon': Icons.person},
    {'label': 'Classes', 'icon': Icons.class_},
    {'label': 'Options', 'icon': Icons.category},
    {'label': 'Paiements', 'icon': Icons.payments},
    {'label': 'Types de frais', 'icon': Icons.label_important}, // 🆕
    {'label': 'Tarifs', 'icon': Icons.attach_money}, // 🆕
    {'label': 'Années', 'icon': Icons.calendar_month},
    {'label': 'Refoulement', 'icon': Icons.assessment},
  ];

  // Pages correspondantes (sans FactureListPage)
  final List<Widget> pages = const [
    EcolePage(),
    DashboardPage(),
    ReportPage(),
    InscriptionPage(),
    UtilisateurPage(),
    ClassePage(),
    OptionPage(),
    PaiementPage(),
    TypeFraisPage(), // 🆕
    TarifFraisPage(), // 🆕
    AnneePage(),
    RefoulementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        final menuList = SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Gestion Inscriptions',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Menu principal',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'Gestion Inscriptions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.only(left: 8, right: 8),
                      children: menuItems.map((item) {
                        final index = menuItems.indexOf(item);
                        final selected = currentIndex == index;
                        return ListTile(
                          leading: Icon(
                            item['icon'] as IconData,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            item['label'] as String,
                            style: TextStyle(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          selected: selected,
                          selectedTileColor: theme.colorScheme.primary
                              .withOpacity(0.14),
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                            if (isMobile) {
                              Navigator.of(context).pop();
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        if (isMobile) {
          return Scaffold(
            appBar: AppBar(
              title: Text(menuItems[currentIndex]['label'] as String),
            ),
            drawer: Drawer(child: menuList),
            body: pages[currentIndex],
          );
        }

        return Scaffold(
          body: Row(
            children: [
              Container(
                width: 260,
                color: theme.colorScheme.surfaceVariant,
                child: menuList,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: pages[currentIndex]),
            ],
          ),
        );
      },
    );
  }
}
