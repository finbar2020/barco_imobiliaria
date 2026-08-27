import 'dart:io';

import 'package:essentials/methods/files/check_file.dart';
import 'package:essentials/methods/files/file_check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FileCheckResult guarda o arquivo e o erro', () {
    final file = File('/tmp/a.pdf');
    final r = FileCheckResult(file: file, error: FileError.size);
    expect(r.file, file);
    expect(r.error, FileError.size);
  });
}
