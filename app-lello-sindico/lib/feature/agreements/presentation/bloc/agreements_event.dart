// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';

abstract class AgreementsEvent {}

class AgreementsEmptyEvent extends AgreementsEvent {}

class AgreementsLoadingEvent extends AgreementsEvent {}

class AgreementsErrorEvent extends AgreementsEvent {
  final Failure? error;
  AgreementsErrorEvent({required this.error});
}

class AgreementsSuccessEvent extends AgreementsEvent {
  final List<Agreement> agreements;

  AgreementsSuccessEvent({
    required this.agreements,
  });
}

class AgreementsSendingEvent extends AgreementsEvent {}

class AgreementsApprovalPostedEvent extends AgreementsEvent {
  final bool approved;
  AgreementsApprovalPostedEvent({
    required this.approved,
  });
}
