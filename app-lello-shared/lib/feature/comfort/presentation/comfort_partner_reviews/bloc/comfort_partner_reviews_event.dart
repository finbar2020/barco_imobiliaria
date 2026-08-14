import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';

abstract class ComfortPartnerReviewsEvent extends Equatable {
  const ComfortPartnerReviewsEvent();

  @override
  List<Object?> get props => [];
}

class EmptyComfortPartnerReviewsEvent extends ComfortPartnerReviewsEvent {
  const EmptyComfortPartnerReviewsEvent();
}

class LoadingComfortPartnerReviewsEvent extends ComfortPartnerReviewsEvent {
  const LoadingComfortPartnerReviewsEvent();
}

class ErrorComfortPartnerReviewsEvent extends ComfortPartnerReviewsEvent {
  final String errorMessageKey;

  const ErrorComfortPartnerReviewsEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class LoadedComfortPartnerReviewsEvent extends ComfortPartnerReviewsEvent {
  final List<ComfortPartnerReview> partnerReviews;
  final String? flushbarMessage;

  const LoadedComfortPartnerReviewsEvent({
    required this.partnerReviews,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [partnerReviews, flushbarMessage];
}
