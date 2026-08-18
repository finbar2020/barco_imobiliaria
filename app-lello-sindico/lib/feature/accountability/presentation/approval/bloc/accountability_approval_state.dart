import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';

import 'package:essentials/essentials.dart';

abstract class AccountabilityApprovalState {}

class AccountabilityApprovalIdleState extends AccountabilityApprovalState {}

class AccountabilityApprovalSetupState extends AccountabilityApprovalState {}

class AccountabilityApprovalLoadingState extends AccountabilityApprovalState {}

class AccountabilityApprovalFailedState extends AccountabilityApprovalState {
  final Failure error;
  AccountabilityApprovalFailedState({
    required this.error,
  });
}

class AccountabilityApprovalApprovedState extends AccountabilityApprovalState {
  final AccountabilityApproval approval;
  AccountabilityApprovalApprovedState({
    required this.approval,
  });
}
