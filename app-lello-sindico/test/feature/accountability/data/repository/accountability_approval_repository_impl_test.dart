import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/data/data_source/accountability_remote_data_source.dart';
import 'package:lello/feature/accountability/data/data_source/approval/accountability_approval_remote_data_source.dart';
import 'package:lello/feature/accountability/data/model/accountability_approval.dart';
import 'package:lello/feature/accountability/data/model/accountability_model.dart';
import 'package:lello/feature/accountability/data/repository/accountability_approval_repository_impl.dart';
import 'package:lello/feature/accountability/data/repository/accountability_repository_impl.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:mockito/mockito.dart';

void main() {
  AccountabilityApprovalRemoteDataSource dataSource;
  AccountabilityApprovalRepository repository;

  final condominiumId = "123";
  final period = DateTime.now();
  final model = AccountabilityApprovalModel();
  final entity = AccountabilityApproval();

  setUp(() {
    dataSource = AccountabilityApprovalRemoteDataSourceMock();
    repository = AccountabilityApprovalRepositoryImpl(dataSource: dataSource);
  });

  group('insert', () {
    test('Should call data source insert', () async {
      when(dataSource.insert(any)).thenAnswer((_) async => model);
      await repository.insert(entity);
      verify(dataSource.insert(any));
    });

    test('Should return success if data source succeeds', () async {
      when(dataSource.insert(any)).thenAnswer((_) async => model);
      final result = await repository.insert(entity);
      expect(result, isA<Success<AccountabilityApproval>>());
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.insert(any)).thenThrow(Exception());
      final result = await repository.insert(entity);
      expect(result, isA<Rejection<AccountabilityApproval>>());
    });
  });
}

class AccountabilityApprovalRemoteDataSourceMock extends Mock
    implements AccountabilityApprovalRemoteDataSource {}
