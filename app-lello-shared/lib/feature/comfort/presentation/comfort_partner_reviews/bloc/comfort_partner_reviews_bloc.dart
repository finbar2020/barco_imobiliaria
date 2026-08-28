import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_state.dart';

class ComfortPartnerReviewsBloc
    extends Bloc<ComfortPartnerReviewsEvent, ComfortPartnerReviewsState> {
  ComfortPartnerReviewsBloc()
      : super(const LoadingComfortPartnerReviewsState()) {
    on<EmptyComfortPartnerReviewsEvent>(handleEmptyComfortPartnerReviewsEvent);
    on<LoadingComfortPartnerReviewsEvent>(
        handleLoadingComfortPartnerReviewsEvent);
    on<ErrorComfortPartnerReviewsEvent>(handleErrorComfortPartnerReviewsEvent);
    on<LoadedComfortPartnerReviewsEvent>(
        handleLoadedComfortPartnerReviewsEvent);
  }
  void handleLoadedComfortPartnerReviewsEvent(
      LoadedComfortPartnerReviewsEvent event,
      Emitter<ComfortPartnerReviewsState> emit) {
    emit(
      LoadedComfortPartnerReviewsState(
        partnerReviews: event.partnerReviews,
        flushbarMessage: event.flushbarMessage,
      ),
    );
  }

  void handleErrorComfortPartnerReviewsEvent(
      ErrorComfortPartnerReviewsEvent event,
      Emitter<ComfortPartnerReviewsState> emit) {
    emit(
      ErrorComfortPartnerReviewsState(errorMessageKey: event.errorMessageKey),
    );
  }

  void handleLoadingComfortPartnerReviewsEvent(
      LoadingComfortPartnerReviewsEvent event,
      Emitter<ComfortPartnerReviewsState> emit) {
    emit(
      const LoadingComfortPartnerReviewsState(),
    );
  }

  void handleEmptyComfortPartnerReviewsEvent(
      EmptyComfortPartnerReviewsEvent event,
      Emitter<ComfortPartnerReviewsState> emit) {
    emit(
      const EmptyComfortPartnerReviewsState(),
    );
  }
}
