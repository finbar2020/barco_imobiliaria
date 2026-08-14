import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_aproval.dart';

abstract class AccountabilityApprovalState extends Equatable {
  const AccountabilityApprovalState();

  @override
  List<Object?> get props => [];
}

class AccountabilityApprovalInitialState extends AccountabilityApprovalState {
  const AccountabilityApprovalInitialState();
}

class AccountabilityApprovalSetupState extends AccountabilityApprovalState {
  const AccountabilityApprovalSetupState();
}

class AccountabilityApprovalLoadingState extends AccountabilityApprovalState {
  const AccountabilityApprovalLoadingState();
}

class AccountabilityApprovalFailedState extends AccountabilityApprovalState {
  final Failure error;

  const AccountabilityApprovalFailedState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AccountabilityApprovalApprovedState extends AccountabilityApprovalState {
  final AccountabilityApproval approval;

  const AccountabilityApprovalApprovedState({required this.approval});

  @override
  List<Object?> get props => [approval];
}
