import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';

import '../../../domain/entity/accountability_aproval.dart';

abstract class AccountabilityApprovalEvent {}

class AccountabilityApprovalSetupEvent extends AccountabilityApprovalEvent {
  final Accountability accountability;
  AccountabilityApprovalSetupEvent({
    required this.accountability,
  });
}

class AccountabilityApprovalIdleEvent extends AccountabilityApprovalEvent {}

class AccountabilityApprovalLoadingEvent extends AccountabilityApprovalEvent {}

class AccountabilityApprovalFailedEvent extends AccountabilityApprovalEvent {
  final Failure error;
  AccountabilityApprovalFailedEvent(
    this.error,
  );
}

class AccountabilityApprovalApprovedEvent extends AccountabilityApprovalEvent {
  final AccountabilityApproval approval;
  AccountabilityApprovalApprovedEvent({
    required this.approval,
  });
}
