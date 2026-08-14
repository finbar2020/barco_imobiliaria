import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_approval_repository.dart';
import 'package:lello/feature/accountability/domain/repository/accountability_repository.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability_impl.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability.dart';
import 'package:lello/feature/accountability/domain/use_case/get_accountability/get_accountability_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  AccountabilityApprovalRepository repository;
  ApproveAccountability approveAccountability;

  final model = Accountability();
  final approval = AccountabilityApproval();

  setUp(() {
    repository = AccountabilityApprovalRepositoryMock();
    approveAccountability = ApproveAccountabilityImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should return rejection when calling with null', () async {
        final result = await approveAccountability.call(null);
        expect(
            result,
            IsAnd<Rejection<AccountabilityApproval>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    group('with vaild parameters', () {
      test('Should call repository select', () async {
        when(repository.insert(any)).thenAnswer((_) async => Success(approval));
        await approveAccountability.call(model);
        verify(repository.insert(any));
      });

      test('Should return success when repository succeeeds', () async {
        when(repository.insert(any)).thenAnswer((_) async => Success(approval));
        final result = await approveAccountability.call(model);
        expect(result, isA<Success<AccountabilityApproval>>());
      });

      test('Should return rejection when repository fails', () async {
        when(repository.insert(any))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await approveAccountability.call(model);
        expect(
            result,
            IsAnd<Rejection<AccountabilityApproval>>(
                (it) => it.get() is UnknownFailure));
      });
    });
  });
}

class AccountabilityApprovalRepositoryMock extends Mock
    implements AccountabilityApprovalRepository {}
