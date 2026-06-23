import 'dart:io';

void main() {
  final home =
      Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
  final base = home == null
      ? null
      : Directory('${home.replaceAll('\\', '/')}').path;
  print('HOME=$home');
  if (base == null) return;
  Directory? cache;
  final pathsToCheck = [
    '${base.replaceAll('\\', '/')}/AppData/Local/Pub/Cache/hosted/pub.dev',
    '${base.replaceAll('\\', '/')}/AppData/Local/Pub/Cache/hosted/pub.dartlang.org',
    '${base.replaceAll('\\', '/')}/AppData/Roaming/Pub/Cache/hosted/pub.dev',
    '${base.replaceAll('\\', '/')}/AppData/Roaming/Pub/Cache/hosted/pub.dartlang.org',
  ];

  for (final path in pathsToCheck) {
    final dir = Directory(path);
    if (dir.existsSync()) {
      cache = dir;
      break;
    }
  }

  if (cache == null) {
    print('SEARCH PATHS=$pathsToCheck');
    print('Cache directory not found');
    return;
  }
  print('SEARCH=${cache.path}');
  for (final dir in cache.listSync()) {
    if (dir is Directory && dir.path.contains('sqlite3-')) {
      final wasm = File('${dir.path}/lib/wasm.dart');
      if (wasm.existsSync()) {
        print('FOUND ${wasm.path}');
        print(wasm.readAsStringSync().split('\n').take(120).join('\n'));
        return;
      }
    }
  }
  print('No sqlite3 wasm.dart found');
}
