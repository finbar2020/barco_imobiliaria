import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_state.dart';

class ValidationMethodBloc
    extends Bloc<ValidationMethodEvent, ValidationMethodState> {
  ValidationMethodBloc() : super(ValidationMethodEmptyState()) {
    on<ValidationMethodEmptyEvent>(handleValidationMethodEmptyEvent);
    on<ValidationMethodLoadingEvent>(handleValidationMethodLoadingEvent);
    on<ValidationMethodSuccessEvent>(handleValidationMethodSuccessEvent);
    on<ValidationMethodFailureEvent>(handleValidationMethodFailureEvent);
  }

  void handleValidationMethodEmptyEvent(
          ValidationMethodEmptyEvent event, Emitter emit) =>
      emit(ValidationMethodEmptyState());

  void handleValidationMethodLoadingEvent(
          ValidationMethodLoadingEvent event, Emitter emit) =>
      emit(ValidationMethodLoadingState());

  void handleValidationMethodSuccessEvent(
          ValidationMethodSuccessEvent event, Emitter emit) =>
      emit(ValidationMethodSuccessState(id: event.id));

  void handleValidationMethodFailureEvent(
          ValidationMethodFailureEvent event, Emitter emit) =>
      emit(ValidationMethodFailureState(error: event.error));
}
