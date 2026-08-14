import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:lello/feature/payroll/data/model/payroll_model.dart';
import 'package:lello/feature/payroll/data/repository/payroll_repository_impl.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PayrollRemoteDataSource dataSource;
  PayrollRepository repository;
  setUp(() {
    dataSource = PayrollRemoteDataSourceMock();
    repository = PayrollRepositoryImpl(remoteDataSource: dataSource);
  });

  final _condominiumId = "1";
  final model = PayrollModel();

  group('list', () {
    test('Should call remote data source', () async {
      when(dataSource.list(_condominiumId)).thenAnswer((_) async => [model]);
      await repository.list(_condominiumId);
      verify(dataSource.list(_condominiumId));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.list(_condominiumId)).thenThrow(Exception());
      final result = await repository.list(_condominiumId);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if remote data source succeeds', () async {
      when(dataSource.list(_condominiumId)).thenAnswer((_) async => [model]);
      final result = await repository.list(_condominiumId);
      expect(result, IsAnd<Success<List<Payroll>>>((it) => it.length() == 1));
    });
  });
}

class PayrollRemoteDataSourceMock extends Mock
    implements PayrollRemoteDataSource {}
