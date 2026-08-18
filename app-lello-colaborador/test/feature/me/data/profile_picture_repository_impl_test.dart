import 'dart:io';

import 'package:colaborador/core/uploader/uploader.dart';
import 'package:colaborador/feature/me/data/repository/profile_picture_repository_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

class _FakeUploader extends Fake implements Uploader {
  bool fail = false;
  String? completedUrl;

  @override
  Future<String> upload(
    String path,
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    if (fail) {
      onError(Exception('upload'));
      throw Exception('upload');
    }
    completedUrl = 'http://done';
    onComplete(completedUrl!);
    return 'task-1';
  }
}

void main() {
  group('ProfilePictureRepositoryImpl', () {
    test('upload retorna task id', () async {
      final uploader = _FakeUploader();
      final result = await ProfilePictureRepositoryImpl(uploader: uploader)
          .upload(
        testTempFile(),
        onComplete: (_) {},
        onError: (_) {},
      );
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).get(), 'task-1');
    });
  });
}
