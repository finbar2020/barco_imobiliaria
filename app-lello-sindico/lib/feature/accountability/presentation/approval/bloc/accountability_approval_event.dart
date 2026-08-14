import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';

import '../../../domain/entity/accountability_aproval.dart';

abstract class AccountabilityApprovalEvent extends Equatable {
  const AccountabilityApprovalEvent();

  @override
  List<Object?> get props => [];
}

class AccountabilityApprovalSetupEvent extends AccountabilityApprovalEvent {
  final Accountability accountability;

  const AccountabilityApprovalSetupEvent({required this.accountability});

  @override
  List<Object?> get props => [accountability];
}

class AccountabilityApprovalInitialEvent extends AccountabilityApprovalEvent {
  const AccountabilityApprovalInitialEvent();
}

class AccountabilityApprovalLoadingEvent extends AccountabilityApprovalEvent {
  const AccountabilityApprovalLoadingEvent();
}

class AccountabilityApprovalFailedEvent extends AccountabilityApprovalEvent {
  final Failure error;

  const AccountabilityApprovalFailedEvent(this.error);

  @override
  List<Object?> get props => [error];
}

class AccountabilityApprovalApprovedEvent extends AccountabilityApprovalEvent {
  final AccountabilityApproval approval;

  const AccountabilityApprovalApprovedEvent({required this.approval});

  @override
  List<Object?> get props => [approval];
}
