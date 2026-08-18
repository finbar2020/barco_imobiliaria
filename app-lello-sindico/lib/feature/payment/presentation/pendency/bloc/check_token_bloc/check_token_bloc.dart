import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_state.dart';

class CheckTokenBloc extends Bloc<CheckTokenEvent, CheckTokenState> {
  CheckTokenBloc() : super(CheckTokenInitial()) {
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
      emit(CheckTokenInitial());

  void handleCheckTokenLoadingEvent(
          CheckTokenLoadingEvent event, Emitter emit) =>
      emit(CheckTokenLoading());

  void handleCheckTokenSuccessEvent(
          CheckTokenSuccessEvent event, Emitter emit) =>
      emit(CheckTokenSuccess(success: event.success));

  void handleCheckTokenFailureEvent(
          CheckTokenFailureEvent event, Emitter emit) =>
      emit(CheckTokenFailure(failure: event.failure));

  void handleResendTokenLoadingEvent(
          ResendTokenLoadingEvent event, Emitter emit) =>
      emit(ResendTokenLoading());

  void handleResendTokenSuccessEvent(
          ResendTokenSuccessEvent event, Emitter emit) =>
      emit(ResendTokenSuccess(id: event.id));

  void handleResendTokenFailureEvent(
          ResendTokenFailureEvent event, Emitter emit) =>
      emit(ResendTokenFailure(failure: event.failure));

  void handleSendActionReasonLoadingEvent(
          SendActionReasonLoadingEvent event, Emitter emit) =>
      emit(SendActionReasonLoading());

  void handleSendActionReasonSuccessEvent(
          SendActionReasonSuccessEvent event, Emitter emit) =>
      emit(SendActionReasonSuccess(success: event.success));

  void handleSendActionReasonFailureEvent(
          SendActionReasonFailureEvent event, Emitter emit) =>
      emit(SendActionReasonFailure(failure: event.failure));

  void handleUpdateInstallmentsLoadingEvent(
          UpdateInstallmentsLoadingEvent event, Emitter emit) =>
      emit(UpdateInstallmentsLoading());

  void handleUpdateInstallmentsSuccessEvent(
          UpdateInstallmentsSuccessEvent event, Emitter emit) =>
      emit(UpdateInstallmentsSuccess(success: event.success));

  void handleUpdateInstallmentsFailureEvent(
          UpdateInstallmentsFailureEvent event, Emitter emit) =>
      emit(UpdateInstallmentsFailure(failure: event.failure));
}
