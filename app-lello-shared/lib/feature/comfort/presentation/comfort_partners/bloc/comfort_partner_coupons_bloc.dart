import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_state.dart';

class ComfortPartnerCouponsBloc
    extends Bloc<ComfortPartnerCouponsEvent, ComfortPartnerCouponsState> {
  ComfortPartnerCouponsBloc() : super(const EmptyCouponsState()) {
    on<EmptyCouponsEvent>(handleEmptyCouponsEvent);
    on<LoadingCouponsEvent>(handleLoadingCouponsEvent);
    on<LoadedCouponsEvent>(handleLoadedCouponsEvent);
    on<CouponsErrorEvent>(handleLoadedCouponsErrorEvent);
  }

  void handleEmptyCouponsEvent(
      EmptyCouponsEvent event, Emitter<ComfortPartnerCouponsState> emit) {
    emit(
      const EmptyCouponsState(),
    );
  }

  void handleLoadingCouponsEvent(
      LoadingCouponsEvent event, Emitter<ComfortPartnerCouponsState> emit) {
    emit(
      const LoadingCouponsState(),
    );
  }

  void handleLoadedCouponsEvent(
      LoadedCouponsEvent event, Emitter<ComfortPartnerCouponsState> emit) {
    emit(
      LoadedCouponsState(
        coupons: event.coupons,
      ),
    );
  }

  void handleLoadedCouponsErrorEvent(
      CouponsErrorEvent event, Emitter<ComfortPartnerCouponsState> emit) {
    emit(
      CouponsErrorState(
        errorMessageKey: event.errorMessageKey,
        errorCode: event.errorCode,
        errorDescription: event.errorDescription,
      ),
    );
  }
}
