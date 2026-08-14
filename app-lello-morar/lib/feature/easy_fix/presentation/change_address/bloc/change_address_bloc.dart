import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_event.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_state.dart';

class ChangeAddressBloc extends Bloc {
  ChangeAddressBloc() : super(const ChangeAddressInitialState()) {
    on<ChangeAddressEmptyEvent>(handleChangeAddressEmptyEvent);
    on<ChangeAddressLoadingEvent>(handleChangeAddressLoadingEvent);
    on<ChangeAddressLoadedEvent>(handleChangeAddressLoadedEvent);
    on<ChangeAddressFailureEvent>(handleChangeAddressFailureEvent);
    on<ChangeAddressSuccessEvent>(handleChangeAddressSuccessEvent);
  }

  void handleChangeAddressEmptyEvent(
      ChangeAddressEmptyEvent event, Emitter emit) {
    emit(const ChangeAddressInitialState());
  }

  void handleChangeAddressLoadedEvent(
      ChangeAddressLoadedEvent event, Emitter emit) {
    emit(ChangeAddressLoadedState(unit: event.unit));
  }

  void handleChangeAddressFailureEvent(
      ChangeAddressFailureEvent event, Emitter emit) {
    emit(ChangeAddressFailureState(failure: event.failure));
  }

  void handleChangeAddressLoadingEvent(
      ChangeAddressLoadingEvent event, Emitter emit) {
    emit(const ChangeAddressLoadingState());
  }

  void handleChangeAddressSuccessEvent(
      ChangeAddressSuccessEvent event, Emitter emit) {
    emit(const ChangeAddressSuccessState());
  }
}
