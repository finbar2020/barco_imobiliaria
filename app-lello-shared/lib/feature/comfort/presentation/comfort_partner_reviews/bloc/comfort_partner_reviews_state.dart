import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';

abstract class ComfortPartnerReviewsState extends Equatable {
  const ComfortPartnerReviewsState();

  @override
  List<Object?> get props => [];
}

class EmptyComfortPartnerReviewsState extends ComfortPartnerReviewsState {
  const EmptyComfortPartnerReviewsState();
}

class LoadingComfortPartnerReviewsState extends ComfortPartnerReviewsState {
  const LoadingComfortPartnerReviewsState();
}

class ErrorComfortPartnerReviewsState extends ComfortPartnerReviewsState {
  final String errorMessageKey;

  const ErrorComfortPartnerReviewsState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class LoadedComfortPartnerReviewsState extends ComfortPartnerReviewsState {
  final List<ComfortPartnerReview> partnerReviews;
  final String? flushbarMessage;

  const LoadedComfortPartnerReviewsState({
    required this.partnerReviews,
    this.flushbarMessage,
  });

  @override
  List<Object?> get props => [partnerReviews, flushbarMessage];
}
