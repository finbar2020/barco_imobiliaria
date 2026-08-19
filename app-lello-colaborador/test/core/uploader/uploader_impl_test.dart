import 'dart:io';

import 'package:colaborador/core/uploader/uploader_impl.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _FakeGetToken extends Fake implements GetToken {
  final params = <GetTokenParams?>[];

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async {
    this.params.add(params);
    return Success(AccessToken()..accessToken = 'token');
  }
}

class _FakeSessionBloc extends Fake implements SessionBloc {}

UploaderImpl _uploader(_FakeGetToken getToken) => UploaderImpl(
      environment: TestEnvironment(),
      getToken: getToken,
      session: _FakeSessionBloc(),
    );

File _missingFile() =>
    File('${Directory.systemTemp.path}/colaborador_inexistente.bin');

void main() {
  group('UploaderImpl', () {
    test('upload usa o token da sessão e avisa erro de arquivo', () async {
      final getToken = _FakeGetToken();
      Exception? reported;

      await expectLater(
        _uploader(getToken).upload(
          'documentos',
          _missingFile(),
          onComplete: (_) {},
          onError: (e) => reported = e,
        ),
        throwsA(isA<Exception>()),
      );

      expect(getToken.params.single?.role, isNull);
      expect(reported, isA<FileSystemException>());
    });

    test('uploadS3 avisa erro quando o arquivo não existe', () async {
      Exception? reported;

      await expectLater(
        _uploader(_FakeGetToken()).uploadS3(
          'https://bucket.exemplo/arquivo',
          _missingFile(),
          onComplete: (_) {},
          onError: (e) => reported = e,
        ),
        throwsA(isA<Exception>()),
      );

      expect(reported, isA<FileSystemException>());
    });

    test('não chama onComplete quando o upload falha', () async {
      var completions = 0;

      await expectLater(
        _uploader(_FakeGetToken()).uploadS3(
          'https://bucket.exemplo/arquivo',
          _missingFile(),
          onComplete: (_) => completions++,
          onError: (_) {},
        ),
        throwsA(isA<Exception>()),
      );

      expect(completions, 0);
    });

    test('mantém o arquivo temporário intacto ao falhar', () async {
      final file = testTempFile();
      addTearDown(() {
        if (file.existsSync()) file.deleteSync();
      });

      expect(file.existsSync(), isTrue);
    });
  });
}
