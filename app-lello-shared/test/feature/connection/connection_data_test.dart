import 'package:dio/dio.dart' as dio;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../authentication/authentication_support.dart';

class _FakeRemote extends Fake implements ConnectionRemoteDataSource {
  _FakeRemote({this.result = true, this.error});
  final bool result;
  final Object? error;

  @override
  Future<bool> healthCheck() async {
    if (error != null) throw error!;
    return result;
  }
}

void main() {
  late LocalHttpServer server;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    server = await LocalHttpServer.start();
  });

  group('ConnectionRemoteDataSourceImpl', () {
    test('consulta /_health na origem da URL base (sem sub-rotas)', () async {
      server.respondJson({'status': 'ok'});
      final dataSource =
          ConnectionRemoteDataSourceImpl(baseUrl: '${server.baseUrl}/api/v2');

      final result = await withRealHttp(dataSource.healthCheck);

      expect(result, isTrue);
      expect(server.requests.single.uri.path, '/_health');
    });

    test('resposta 2xx que não é 200 lança a própria resposta', () async {
      server.handler = (req) async {
        req.response.statusCode = 204;
        await req.response.close();
      };
      final dataSource = ConnectionRemoteDataSourceImpl(baseUrl: server.baseUrl);

      await expectLater(withRealHttp(dataSource.healthCheck),
          throwsA(isA<dio.Response>()));
    });

    test('erro do servidor lança DioException', () async {
      server.respondText('erro', status: 503);
      final dataSource = ConnectionRemoteDataSourceImpl(baseUrl: server.baseUrl);

      await expectLater(withRealHttp(dataSource.healthCheck),
          throwsA(isA<dio.DioException>()));
    });
  });

  group('ConnectionRepositoryImpl e ConnectionUseCaseImpl', () {
    test('sucesso devolve o resultado', () async {
      final repository =
          ConnectionRepositoryImpl(remoteDataSource: _FakeRemote());
      expect((await repository.healthCheck()).fold((_) => false, (r) => r),
          isTrue);

      final useCase = ConnectionUseCaseImpl(repository: repository);
      expect((await useCase.call(ConnectionParams())).fold((_) => false, (r) => r),
          isTrue);
    });

    test('exceção vira UnknownFailure', () async {
      final repository = ConnectionRepositoryImpl(
          remoteDataSource: _FakeRemote(error: StateError('boom')));

      final result = await repository.healthCheck();

      expect((result as Rejection).get(), isA<UnknownFailure>());
    });
  });
}
