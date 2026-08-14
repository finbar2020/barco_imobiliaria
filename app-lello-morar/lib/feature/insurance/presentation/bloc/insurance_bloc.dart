import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_event.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  InsuranceBloc() : super(const LoadingInsuranceState()) {
    on<InsuranceLoadingEvent>(handleInsuranceLoadingEvent);
    on<InsuranceLoadedEvent>(handleInsuranceLoadedEvent);
    on<InsuranceFailedEvent>(handleInsuranceFailedEvent);
  }

  void handleInsuranceLoadingEvent(InsuranceLoadingEvent event, Emitter emit) =>
      emit(const LoadingInsuranceState());

  void handleInsuranceLoadedEvent(InsuranceLoadedEvent event, Emitter emit) =>
      emit(LoadedInsuranceState(
        model: event.model,
        isCancel: event.isCancel,
        isPost: event.isPost,
        selectedPremium: event.selectedPremium,
        insuranceData: event.insuranceData,
      ));

  void handleInsuranceFailedEvent(InsuranceFailedEvent event, Emitter emit) =>
      emit(const FailedInsuranceState());
}
