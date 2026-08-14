import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_state.dart';

class CheckTokenBloc extends Bloc<CheckTokenEvent, CheckTokenState> {
  CheckTokenBloc() : super(const CheckTokenInitialState()) {
    on<CheckTokenInitialEvent>(handleCheckTokenInitialEvent);
    on<CheckTokenLoadingEvent>(handleCheckTokenLoadingEvent);
    on<CheckTokenSuccessEvent>(handleCheckTokenSuccessEvent);
    on<CheckTokenFailureEvent>(handleCheckTokenFailureEvent);
    on<ResendTokenLoadingEvent>(handleResendTokenLoadingEvent);
    on<ResendTokenSuccessEvent>(handleResendTokenSuccessEvent);
    on<ResendTokenFailureEvent>(handleResendTokenFailureEvent);
    on<SendActionReasonLoadingEvent>(handleSendActionReasonLoadingEvent);
    on<SendActionReasonSuccessEvent>(handleSendActionReasonSuccessEvent);
    on<SendActionReasonFailureEvent>(handleSendActionReasonFailureEvent);
    on<UpdateInstallmentsLoadingEvent>(handleUpdateInstallmentsLoadingEvent);
    on<UpdateInstallmentsSuccessEvent>(handleUpdateInstallmentsSuccessEvent);
    on<UpdateInstallmentsFailureEvent>(handleUpdateInstallmentsFailureEvent);
  }

  void handleCheckTokenInitialEvent(
          CheckTokenInitialEvent event, Emitter emit) =>
      emit(const CheckTokenInitialState());

  void handleCheckTokenLoadingEvent(
          CheckTokenLoadingEvent event, Emitter emit) =>
      emit(const CheckTokenLoadingState());

  void handleCheckTokenSuccessEvent(
          CheckTokenSuccessEvent event, Emitter emit) =>
      emit(CheckTokenSuccessState(success: event.success));

  void handleCheckTokenFailureEvent(
          CheckTokenFailureEvent event, Emitter emit) =>
      emit(CheckTokenFailureState(failure: event.failure));

  void handleResendTokenLoadingEvent(
          ResendTokenLoadingEvent event, Emitter emit) =>
      emit(const ResendTokenLoadingState());

  void handleResendTokenSuccessEvent(
          ResendTokenSuccessEvent event, Emitter emit) =>
      emit(ResendTokenSuccessState(id: event.id));

  void handleResendTokenFailureEvent(
          ResendTokenFailureEvent event, Emitter emit) =>
      emit(ResendTokenFailureState(failure: event.failure));

  void handleSendActionReasonLoadingEvent(
          SendActionReasonLoadingEvent event, Emitter emit) =>
      emit(const SendActionReasonLoadingState());

  void handleSendActionReasonSuccessEvent(
          SendActionReasonSuccessEvent event, Emitter emit) =>
      emit(SendActionReasonSuccessState(success: event.success));

  void handleSendActionReasonFailureEvent(
          SendActionReasonFailureEvent event, Emitter emit) =>
      emit(SendActionReasonFailureState(failure: event.failure));

  void handleUpdateInstallmentsLoadingEvent(
          UpdateInstallmentsLoadingEvent event, Emitter emit) =>
      emit(const UpdateInstallmentsLoadingState());

  void handleUpdateInstallmentsSuccessEvent(
          UpdateInstallmentsSuccessEvent event, Emitter emit) =>
      emit(UpdateInstallmentsSuccessState(success: event.success));

  void handleUpdateInstallmentsFailureEvent(
          UpdateInstallmentsFailureEvent event, Emitter emit) =>
      emit(UpdateInstallmentsFailureState(failure: event.failure));
}
