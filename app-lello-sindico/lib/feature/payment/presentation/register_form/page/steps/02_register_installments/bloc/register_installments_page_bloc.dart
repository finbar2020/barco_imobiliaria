import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/bloc/register_installments_page_event.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/bloc/register_installments_page_state.dart';

class RegisterInstallmentsBloc
    extends Bloc<RegisterInstallmentsEvent, RegisterInstallmentsState> {
  RegisterInstallmentsBloc() : super(RegisterInstallmentsEmptyState()) {
    on<RegisterInstallmentsEmptyEvent>(handleRegisterInstallmentsEmptyEvent);
    on<RegisterInstallmentsLoadingEvent>(
        handleRegisterInstallmentsLoadingEvent);
    on<RegisterInstallmentsSuccessEvent>(
        handleRegisterInstallmentsSuccessEvent);
    on<RegisterInstallmentsFailureEvent>(
        handleRegisterInstallmentsFailureEvent);
  }

  void handleRegisterInstallmentsEmptyEvent(
          RegisterInstallmentsEmptyEvent event, Emitter emit) =>
      emit(RegisterInstallmentsEmptyState());

  void handleRegisterInstallmentsLoadingEvent(
          RegisterInstallmentsLoadingEvent event, Emitter emit) =>
      emit(RegisterInstallmentsLoadingState());

  void handleRegisterInstallmentsSuccessEvent(
          RegisterInstallmentsSuccessEvent event, Emitter emit) =>
      emit(RegisterInstallmentsSuccessState(value: event.value));

  void handleRegisterInstallmentsFailureEvent(
          RegisterInstallmentsFailureEvent event, Emitter emit) =>
      emit(RegisterInstallmentsFailureState(error: event.error));
}
