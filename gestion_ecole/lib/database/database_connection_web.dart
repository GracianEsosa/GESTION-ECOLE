import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

QueryExecutor openDatabaseConnectionImpl() {
  return LazyDatabase(() async {
    return WebDatabase('gestion_scolaire_db');
  });
}
