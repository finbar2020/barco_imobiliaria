// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';

abstract class AgreementsState {}

class AgreementsEmptyState extends AgreementsState {}

class AgreementsLoadingState extends AgreementsState {}

class AgreementsErrorState extends AgreementsState {
  final Failure? error;
  AgreementsErrorState({required this.error});
}

class AgreementsSuccessState extends AgreementsState {
  final List<Agreement> agreements;

  AgreementsSuccessState({
    required this.agreements,
  });
}

class AgreementsSendingState extends AgreementsState {}

class AgreementsApprovalPostedState extends AgreementsState {
  final bool approved;
  AgreementsApprovalPostedState({
    required this.approved,
  });
}
