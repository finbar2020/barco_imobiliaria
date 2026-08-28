import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';

class ComfortPartnersBloc
    extends Bloc<ComfortPartnersEvent, ComfortPartnersState> {
  ComfortPartnersBloc() : super(const EmptyComfortPartnersState()) {
    on<SuccessComfortPartnersEvent>(handleSuccessComfortPartnersEvent);
    on<EmptyComfortPartnersEvent>(handleEmptyComfortPartnersEvent);
    on<LoadingComfortPartnersEvent>(handleLoadingComfortPartnersEvent);
    on<ErrorComfortPartnersEvent>(handleErrorComfortPartnersEvent);
    on<LoadedComfortPartnersEvent>(handleLoadedComfortPartnersEvent);
    on<LoadedComfortPartnerDetailsEvent>(
        handleLoadedComfortPartnerDetailsEvent);
    on<SuccessComfortPartnerCupomEvent>(handleSuccessComfortPartnerCupomEvent);
    on<SuccessReviewSentEvent>(handleSuccessReviewSentEvent);
  }

  void handleSuccessReviewSentEvent(
      SuccessReviewSentEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      const SuccessReviewSentState(),
    );
  }

  void handleLoadedComfortPartnerDetailsEvent(
      LoadedComfortPartnerDetailsEvent event,
      Emitter<ComfortPartnersState> emit) {
    // `SuccessComfortPartnerCupomEvent` herda deste evento e tem o seu
    // próprio handler: sem esta guarda o bloc emitiria um
    // `LoadedComfortPartnerDetailsState` intermediário antes do estado de
    // sucesso (a tela pisca os detalhes antes do cupom).
    if (event is SuccessComfortPartnerCupomEvent) return;
    emit(
      LoadedComfortPartnerDetailsState(
        selectedPartner: event.selectedPartner,
        couponRequest: event.couponRequest,
        requestPurchase: event.requestPurchase,
        error: event.error,
      ),
    );
  }

  void handleSuccessComfortPartnerCupomEvent(
      SuccessComfortPartnerCupomEvent event,
      Emitter<ComfortPartnersState> emit) {
    emit(
      SuccessComfortPartnerCupomState(
        selectedPartner: event.selectedPartner,
        couponRequest: event.couponRequest,
        requestPurchase: event.requestPurchase,
        error: event.error,
      ),
    );
  }

  void handleLoadedComfortPartnersEvent(
      LoadedComfortPartnersEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      LoadedComfortPartnersState(
        comfortPartnerCategoryIsFilter: event.comfortPartnerCategoryIsFilter,
        comfortPartnersIsRandomic: event.comfortPartnersIsRandomic,
        categoriesToYourCondo: event.categoriesToYourCondo,
        isFailedCondoPartners: event.isFailedCondoPartners,
        isSuccessYourCondoPartners: event.isSuccessYourCondoPartners,
        partnerFocus: event.partnerFocus,
        flushbarMessage: event.flushbarMessage,
      ),
    );
  }

  void handleErrorComfortPartnersEvent(
      ErrorComfortPartnersEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      ErrorComfortPartnersState(
          errorMessageKey: event.errorMessageKey,
          errorCode: event.errorCode,
          errorDescription: event.errorDescription),
    );
  }

  void handleSuccessComfortPartnersEvent(
      SuccessComfortPartnersEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      SuccessComfortPartnersState(selectedPartner: event.selectedPartner),
    );
  }

  void handleEmptyComfortPartnersEvent(
      EmptyComfortPartnersEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      const EmptyComfortPartnersState(),
    );
  }

  void handleLoadingComfortPartnersEvent(
      LoadingComfortPartnersEvent event, Emitter<ComfortPartnersState> emit) {
    emit(
      const LoadingComfortPartnersState(),
    );
  }
}
