import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../services/classe_service.dart';

////////////////////////////////////////////////////
/// SERVICE
////////////////////////////////////////////////////

final classeServiceProvider = Provider<ClasseService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ClasseService(db);
});

////////////////////////////////////////////////////
/// LISTE DES CLASSES
////////////////////////////////////////////////////

final classesListProvider = FutureProvider<List<ClassesData>>((ref) async {
  final service = ref.watch(classeServiceProvider);
  return service.getClasses();
});

////////////////////////////////////////////////////
/// CLASSES NON SYNCHRONISÉES
////////////////////////////////////////////////////

final unsyncedClassesProvider = FutureProvider<List<ClassesData>>((ref) async {
  final service = ref.watch(classeServiceProvider);
  return service.getUnsyncedClasses();
});

////////////////////////////////////////////////////
/// RECHERCHE
////////////////////////////////////////////////////

final searchClassesProvider = FutureProvider.family<List<ClassesData>, String>((
  ref,
  motCle,
) async {
  final service = ref.watch(classeServiceProvider);
  return service.rechercherClasses(motCle);
});

////////////////////////////////////////////////////
/// RAFRAÎCHIR
////////////////////////////////////////////////////

final refreshClassesProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(classesListProvider);
  };
});
