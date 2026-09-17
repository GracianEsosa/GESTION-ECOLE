import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ecole_provider.dart';
import '../services/ecole_service.dart';
import '../utils/file_image_provider.dart';

class EcolePage extends ConsumerStatefulWidget {
  const EcolePage({super.key});

  @override
  ConsumerState<EcolePage> createState() => _EcolePageState();
}

class _EcolePageState extends ConsumerState<EcolePage> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _adresse = TextEditingController();
  final _telephone = TextEditingController();
  final _email = TextEditingController();
  final _logo = TextEditingController();
  String _devise = 'FCFA';
  bool _loaded = false;

  @override
  void dispose() {
    _nom.dispose(); _adresse.dispose(); _telephone.dispose(); _email.dispose(); _logo.dispose();
    super.dispose();
  }

  void _load(EcoleInfo? ecole) {
    if (_loaded) return;
    _loaded = true;
    _nom.text = ecole?.nom ?? '';
    _adresse.text = ecole?.adresse ?? '';
    _telephone.text = ecole?.telephone ?? '';
    _email.text = ecole?.email ?? '';
    _logo.text = ecole?.logoPath ?? '';
    _devise = ecole?.devise ?? 'FCFA';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(ecoleServiceProvider).enregistrer(EcoleInfo(
      nom: _nom.text.trim(), adresse: _adresse.text.trim().isEmpty ? null : _adresse.text.trim(),
      telephone: _telephone.text.trim().isEmpty ? null : _telephone.text.trim(),
      email: _email.text.trim().isEmpty ? null : _email.text.trim(),
      devise: _devise, logoPath: _logo.text.trim().isEmpty ? null : _logo.text.trim(),
    ));
    ref.invalidate(ecoleProvider);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informations de l’école enregistrées.')));
  }

  @override
  Widget build(BuildContext context) {
    final ecole = ref.watch(ecoleProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Informations de l’école')),
      body: ecole.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur : $error')),
        data: (data) {
          _load(data);
          final logo = _logo.text.trim();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (logo.isNotEmpty) Center(child: CircleAvatar(radius: 52, backgroundImage: fileImageProvider(logo))),
                const SizedBox(height: 16),
                TextFormField(controller: _nom, decoration: const InputDecoration(labelText: 'Nom de l’école *', border: OutlineInputBorder()), validator: (v) => v == null || v.trim().isEmpty ? 'Le nom est requis' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _adresse, decoration: const InputDecoration(labelText: 'Adresse', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: _telephone, decoration: const InputDecoration(labelText: 'Téléphone', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(value: _devise, decoration: const InputDecoration(labelText: 'Devise', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'FCFA', child: Text('FCFA')), DropdownMenuItem(value: 'CDF', child: Text('CDF'))], onChanged: (v) => setState(() => _devise = v!)),
                const SizedBox(height: 12),
                TextFormField(controller: _logo, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Chemin de la photo / logo', hintText: 'C:\\Images\\logo.png', border: OutlineInputBorder())),
                const SizedBox(height: 8),
                const Text('Indiquez le chemin local de votre logo pour l’afficher dans l’application.', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 20),
                FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Enregistrer')),
              ]),
            ),
          );
        },
      ),
    );
  }
}
