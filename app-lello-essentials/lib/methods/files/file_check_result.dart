import 'dart:io';

import 'package:essentials/methods/files/check_file.dart';

class FileCheckResult {
  final File file;
  final FileError error;

  FileCheckResult({required this.file, required this.error});
}
