import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';
import 'package:lello/feature/accountability/domain/use_case/approve_accountability/approve_accountability.dart';
import 'package:lello/feature/accountability/presentation/bloc/approval/accountability_approval_bloc_impl.dart';
import 'package:lello/feature/accountability/presentation/bloc/approval/accountability_approval_state.dart';
import 'package:mockito/mockito.dart';

import '../../../../matcher/is_and_matcher.dart';

void main() {
  ApproveAccountability approveAccountability;
  AccountabilityApprovalBlocImpl bloc;

  var _data = Accountability();
  var _approval = AccountabilityApproval();
  setUp(() {
    approveAccountability = ApproveAccountabilityMock();
    bloc = AccountabilityApprovalBlocImpl(
        approveAccountability: approveAccountability);
  });

  group('begin setup', () {
    test('Should emit idle state with data', () async {
      bloc.beginSetup(_data);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<AccountabilityApprovalIdleState>(),
            IsAnd<AccountabilityApprovalIdleState>((it) => it.data == _data),
          ]));
    });
  });

  group('begin approve', () {
    void setupBloc() async {
      bloc.beginSetup(_data);

      await expectLater(
          bloc,
          emitsInOrder([
            isA<AccountabilityApprovalIdleState>(),
            isA<AccountabilityApprovalIdleState>()
          ]));
    }

    test('Should not emit anything if setup was not called', () async {
      bloc.beginApprove();
      expect(
          bloc,
          emitsInOrder([
            isA<AccountabilityApprovalIdleState>(),
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setupBloc();

      when(approveAccountability.call(any))
          .thenAnswer((_) async => Success(_approval));
      bloc.beginApprove();

      await expectLater(
          bloc,
          emitsInOrder([
            isA<AccountabilityApprovalIdleState>(),
            isA<AccountabilityApprovalLoadingState>(),
            IsAnd<AccountabilityApprovalApprovedState>((it) => it.data == _data)
          ]));
    });

    test('Should emit loading state when state is already loaded', () async {
      await setupBloc();

      when(approveAccountability.call(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      bloc.beginApprove();

      expect(
          bloc,
          emitsInOrder([
            isA<AccountabilityApprovalIdleState>(),
            isA<AccountabilityApprovalLoadingState>(),
            IsAnd<AccountabilityApprovalFailedState>(
                (it) => it.error is UnknownFailure)
          ]));
    });
  });
}

class ApproveAccountabilityMock extends Mock implements ApproveAccountability {}
