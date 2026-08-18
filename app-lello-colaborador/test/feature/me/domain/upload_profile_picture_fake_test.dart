import 'dart:io';

import 'package:colaborador/feature/me/domain/repository/profile_picture_repository.dart';
import 'package:colaborador/feature/me/domain/use_case/upload_profile_picture/upload_registration_picture_impl.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

class _FakeProfileRepo extends Fake implements ProfilePictureRepository {
  bool fail = false;

  @override
  Future<Try<String>> upload(
    File file, {
    required Function(String) onComplete,
    required Function(Exception) onError,
  }) async {
    if (fail) {
      onError(Exception('upload fail'));
      return Rejection(UnknownFailure('upload fail'));
    }
    onComplete('http://picture.url');
    return Success('task-1');
  }
}

class _TrackingSessionBloc extends Fake implements SessionBloc {
  bool beganLoad = false;

  @override
  void beginLoadSession({bool onLogin = false, bool onlyLocal = false}) {
    beganLoad = true;
  }
}

void main() {
  group('UploadProfilePictureImpl', () {
    test('envia foto e recarrega sessão', () async {
      final session = _TrackingSessionBloc();
      final result = await UploadProfilePictureImpl(
        uploader: _FakeProfileRepo(),
        sessionBloc: session,
      )(testTempFile());
      expect(result, isA<Success<String>>());
      expect((result as Success<String>).get(), 'http://picture.url');
      expect(session.beganLoad, isTrue);
    });

    test('rejeita falha de upload', () async {
      final result = await UploadProfilePictureImpl(
        uploader: _FakeProfileRepo()..fail = true,
        sessionBloc: _TrackingSessionBloc(),
      )(testTempFile());
      expect(result, isA<Rejection<String>>());
    });
  });
}
