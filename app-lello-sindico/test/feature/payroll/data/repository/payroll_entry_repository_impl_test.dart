import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payroll/data/data_source/payroll/payroll_remote_data_source.dart';
import 'package:lello/feature/payroll/data/data_source/payroll_entry/payroll_entry_remote_data_source.dart';
import 'package:lello/feature/payroll/data/model/payroll_entry_model.dart';
import 'package:lello/feature/payroll/data/model/payroll_model.dart';
import 'package:lello/feature/payroll/data/repository/payroll_entry_repository_impl.dart';
import 'package:lello/feature/payroll/data/repository/payroll_repository_impl.dart';
import 'package:lello/feature/payroll/domain/entity/payroll.dart';
import 'package:lello/feature/payroll/domain/entity/payroll_entry.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_entry_repository.dart';
import 'package:lello/feature/payroll/domain/repository/payroll_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PayrollEntryRemoteDataSource dataSource;
  PayrollEntryRepository repository;
  setUp(() {
    dataSource = PayrollEntryRemoteDataSourceMock();
    repository = PayrollEntryRepositoryImpl(remoteDataSource: dataSource);
  });

  final _condominiumId = "1";
  final _period = DateTime.now();
  final model = PayrollEntryModel();

  group('list', () {
    test('Should call remote data source', () async {
      when(dataSource.list(_condominiumId, _period))
          .thenAnswer((_) async => [model]);
      await repository.list(_condominiumId, _period);
      verify(dataSource.list(_condominiumId, _period));
    });

    test('Should return rejection if remote data source throws any error',
        () async {
      when(dataSource.list(_condominiumId, _period)).thenThrow(Exception());
      final result = await repository.list(_condominiumId, _period);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if remote data source succeeds', () async {
      when(dataSource.list(_condominiumId, _period))
          .thenAnswer((_) async => [model]);
      final result = await repository.list(_condominiumId, _period);
      expect(
          result, IsAnd<Success<List<PayrollEntry>>>((it) => it.length() == 1));
    });
  });
}

class PayrollEntryRemoteDataSourceMock extends Mock
    implements PayrollEntryRemoteDataSource {}
