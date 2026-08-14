import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_local_data_source.dart';
import 'package:lello/feature/condominium/data/data_source/remote/condominium_balance_remote_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:lello/feature/condominium/data/repository/condominium_balance_repository_impl.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/repository/condominium_balance_repository.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:mockito/mockito.dart';

void main() {
  CondominiumBalanceRemoteDataSource dataSource;
  CondominiumBalanceLocalDataSource localDataSource;
  CondominiumBalanceRepository repository;

  final _id = "123";
  final _model = CondominiumBalanceModel();

  setUp(() {
    dataSource = CondominiumBalanceRemoteDataSourceMock();
    repository = CondominiumBalanceRepositoryImpl(
        remoteDataSource: dataSource, localDataSource: localDataSource);
  });

  group('select', () {
    test('Should call data source', () async {
      when(dataSource.select(_id)).thenAnswer((_) async => _model);
      await repository.select(new CondominiumBalanceParam(id: _id));
      verify(dataSource.select(_id));
    });

    test('Should return success when datasource succeeds', () async {
      when(dataSource.select(_id)).thenAnswer((_) async => _model);
      final result =
          await repository.select(new CondominiumBalanceParam(id: _id));
      expect(result, isA<Success<CondominiumBalance>>());
    });

    test('Should return rejection when datasource throws an exception',
        () async {
      when(dataSource.select(_id)).thenThrow(Exception());
      final result =
          await repository.select(new CondominiumBalanceParam(id: _id));
      expect(result, isA<Rejection<CondominiumBalance>>());
    });
  });
}

class CondominiumBalanceRemoteDataSourceMock extends Mock
    implements CondominiumBalanceRemoteDataSource {}
