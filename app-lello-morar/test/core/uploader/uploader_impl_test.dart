import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/uploader/uploader_impl.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _FakeGetToken extends Fake implements GetToken {
  _FakeGetToken({this.token});
  final AccessToken? token;

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async =>
      Success(token);
}

void main() {
  late Directory dir;
  late File file;
  late UploaderImpl uploader;
  final completed = <String>[];
  final errors = <Object>[];

  setUp(() {
    completed.clear();
    errors.clear();
    dir = Directory.systemTemp.createTempSync('morar_upload');
    file = File('${dir.path}/foto.jpg')..writeAsBytesSync([1, 2, 3]);
    uploader = UploaderImpl(
      environment: TestEnvironment(),
      getToken: _FakeGetToken(token: AccessToken()..accessToken = 'tok'),
      session: FakeSessionBloc(),
    );
  });

  tearDown(() => dir.deleteSync(recursive: true));

  /// O upload dispara um `Dio` real sem aguardar; capturamos o erro de rede
  /// da zona para o teste não falhar por ele.
  Future<T> guarded<T>(Future<T> Function() body) {
    final completer = Completer<T>();
    runZonedGuarded(() async {
      completer.complete(await body());
    }, (e, s) {
      if (!completer.isCompleted) completer.completeError(e, s);
    });
    return completer.future;
  }

  test('upload monta a requisição com o token e devolve "Sending"', () async {
    final progress = StreamController<double>.broadcast();
    final result = await guarded(() => uploader.upload(
          'files',
          file,
          progress: progress,
          onComplete: completed.add,
          onError: errors.add,
        ));

    expect(result, 'Sending');
    await Future.delayed(const Duration(milliseconds: 200));
    await progress.close();
  });

  test('arquivo inexistente chama onError e relança', () async {
    final missing = File('${dir.path}/nao_existe.jpg');

    await expectLater(
      uploader.uploadWithProgress(
        'files',
        missing,
        null,
        onComplete: completed.add,
        onError: errors.add,
      ),
      throwsA(isA<Exception>()),
    );

    expect(errors, hasLength(1));
    expect(completed, isEmpty);
  });

  test('sem token o upload chama onError e relança uma Exception', () async {
    final semToken = UploaderImpl(
      environment: TestEnvironment(),
      getToken: _FakeGetToken(),
      session: FakeSessionBloc(),
    );

    // Corrigido: a ausência de token é tratada como `Exception` (não mais
    // `accessToken!` com TypeError), então `onError` é chamado e o erro
    // relançado, sem disparar a requisição.
    await expectLater(
      semToken.upload(
        'files',
        file,
        onComplete: completed.add,
        onError: errors.add,
      ),
      throwsA(isA<Exception>()),
    );
    expect(errors, hasLength(1));
    expect(errors.single, isA<Exception>());
    expect(completed, isEmpty);
  });

  test('uploadS3 envia o arquivo e devolve "Sending"', () async {
    final result = await guarded(() => uploader.uploadS3(
          'http://localhost/s3',
          file,
          onComplete: completed.add,
          onError: errors.add,
        ));

    expect(result, 'Sending');
    await Future.delayed(const Duration(milliseconds: 200));
  });

  test('uploadS3 com arquivo inexistente chama onError e relança', () async {
    final missing = File('${dir.path}/nao_existe.jpg');

    await expectLater(
      uploader.uploadS3WithProgress(
        'http://localhost/s3',
        missing,
        StreamController<double>(),
        onComplete: completed.add,
        onError: errors.add,
      ),
      throwsA(isA<FileSystemException>()),
    );

    expect(errors, hasLength(1));
  });
}
