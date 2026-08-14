import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';

abstract class AgreementsEvent extends Equatable {
  const AgreementsEvent();

  @override
  List<Object?> get props => [];
}

class AgreementsGetQuotaAvailableEvent extends AgreementsEvent {
  const AgreementsGetQuotaAvailableEvent();
}

class AgreementsGetChoicesPaymentEvent extends AgreementsEvent {
  const AgreementsGetChoicesPaymentEvent();
}

class AgreementsGetRecommendationPaymentEvent extends AgreementsEvent {
  const AgreementsGetRecommendationPaymentEvent();
}

class AgreementsGetPaydayEvent extends AgreementsEvent {
  const AgreementsGetPaydayEvent();
}

class GoToRecommendationPaymentEvent extends AgreementsEvent {
  const GoToRecommendationPaymentEvent();
}

class GoToAgreementstEvent extends AgreementsEvent {
  const GoToAgreementstEvent();
}

class AgreementsGetInstallmentEvent extends AgreementsEvent {
  final double totalValue;

  const AgreementsGetInstallmentEvent({
    required this.totalValue,
  });

  @override
  List<Object?> get props => [totalValue];
}

class GoToInstallmentEvent extends AgreementsEvent {
  const GoToInstallmentEvent();
}

class PostAgreementEvent extends AgreementsEvent {
  final AgreementCreated agreement;
  final bool pendingProposal;
  final bool creditCard;

  const PostAgreementEvent({
    required this.agreement,
    required this.pendingProposal,
    required this.creditCard,
  });

  @override
  List<Object?> get props => [agreement, pendingProposal, creditCard];
}

class AgreementsDetailsEvent extends AgreementsEvent {
  final String agreementId;

  const AgreementsDetailsEvent({
    required this.agreementId,
  });

  @override
  List<Object?> get props => [agreementId];
}

class GetAgreementBilletEvent extends AgreementsEvent {
  final String installmentId;

  const GetAgreementBilletEvent({
    required this.installmentId,
  });

  @override
  List<Object?> get props => [installmentId];
}
