import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_event.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_state.dart';

class CertificateNoOutstandingDebtBloc extends Bloc {
  CertificateNoOutstandingDebtBloc()
      : super(const CertificateNoOutstandingDebtInitialState()) {
    on<UnitProfileLoadingEvent>(handleUnitProfileLoadingEvent);
    on<UnitProfileFailureEvent>(handleUnitProfileFailureEvent);
    on<UnitProfileLoadedEvent>(handleUnitProfileLoadedEvent);
    //Events Certificate No Outstanding Debt
    on<CertificateNoOutstandingDebtLoadingEvent>(
        handleCertificateNoOutstandingDebtLoadingEvent);
    on<CertificateNoOutstandingDebtFailureEvent>(
        handleCertificateNoOutstandingDebtFailureState);
    on<HasOutstandingDebtEvent>(handleUserHasOutstandingDebtEvent);
    on<CertificateNoOutstandingDebtSucessEvent>(
        handleCertificateNoOutstandingDebtSucessEvent);
  }

  void handleCertificateNoOutstandingDebtFailureState(
      CertificateNoOutstandingDebtFailureEvent event, Emitter emit) {
    emit(CertificateNoOutstandingDebtFailureState(failure: event.failure));
  }

  void handleUnitProfileLoadedEvent(
      UnitProfileLoadedEvent event, Emitter emit) {
    emit(UnitProfileLoadedState(unit: event.unit));
  }

  void handleUserHasOutstandingDebtEvent(
      HasOutstandingDebtEvent event, Emitter emit) {
    emit(const HasOutstandingDebtState());
  }

  void handleUnitProfileFailureEvent(
      UnitProfileFailureEvent event, Emitter emit) {
    emit(UnitProfileFailureState(failure: event.failure));
  }

  void handleCertificateNoOutstandingDebtSucessEvent(
      CertificateNoOutstandingDebtSucessEvent event, Emitter emit) {
    emit(CertificateNoOutstandingDebtSucessState(pdf: event.pdf));
  }

  void handleCertificateNoOutstandingDebtLoadingEvent(
      CertificateNoOutstandingDebtLoadingEvent event, Emitter emit) {
    emit(const CertificateNoOutstandingDebtLoadingState());
  }

  void handleUnitProfileLoadingEvent(
      UnitProfileLoadingEvent event, Emitter emit) {
    emit(const UnitProfileLoadingState());
  }
}
