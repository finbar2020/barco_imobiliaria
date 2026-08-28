import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

class _SyncThrowingDataSource extends Fake
    implements ExpiredSessionLocalDataSource {
  @override
  Future<void> clear() => throw StateError('boom');
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'chave': 'valor'});
  });

  test('ExpiredSessionLocalDataSourceImpl limpa as preferências e o banco',
      () async {
    var resets = 0;
    final dataSource = ExpiredSessionLocalDataSourceImpl(resetDb: () async {
      resets++;
      return Success(Nothing());
    });

    await dataSource.clear();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString('chave'), isNull);
    expect(resets, 1);
  });

  test('ExpiredSessionRepositoryImpl devolve sucesso e rejeição', () async {
    var resets = 0;
    final repository = ExpiredSessionRepositoryImpl(
      localDataSource: ExpiredSessionLocalDataSourceImpl(resetDb: () async {
        resets++;
        return Success(Nothing());
      }),
    );

    final result = await repository.clear();
    await Future<void>.delayed(Duration.zero);

    expect(result, isA<Success<Nothing>>());
    expect(resets, 1);

    final failing =
        ExpiredSessionRepositoryImpl(localDataSource: _SyncThrowingDataSource());
    final rejected = await failing.clear();
    expect((rejected as Rejection).get(), isA<UnknownFailure>());
  });

  test('ClearDataImpl limpa as preferências', () async {
    final result = await ClearDataImpl().call();

    expect(result, isA<Success<Nothing>>());
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getKeys(), isEmpty);
  });

  test('ExpiredSessionArguments guarda os dados do diagnóstico', () {
    final args = ExpiredSessionArguments(
      reason: 'r',
      cpf: 'c',
      accessToken: 'a',
      refreshToken: 'f',
      failure: 'x',
      timestamp: 't',
      source: 's',
      information: ['i'],
    );
    expect(args.reason, 'r');
    expect(args.cpf, 'c');
    expect(args.accessToken, 'a');
    expect(args.refreshToken, 'f');
    expect(args.failure, 'x');
    expect(args.timestamp, 't');
    expect(args.source, 's');
    expect(args.information, ['i']);
  });
}
