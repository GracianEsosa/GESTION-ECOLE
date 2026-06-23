import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

final appDatabaseProvider = Provider((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
