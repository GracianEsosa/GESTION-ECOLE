import 'dart:io';
import 'package:flutter/widgets.dart';

ImageProvider<Object>? fileImageProviderImpl(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  return FileImage(file);
}
