import 'package:bloc/bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:meta/meta.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';

part 'comfort_my_request_item_actions_event.dart';
part 'comfort_my_request_item_actions_state.dart';

class ComfortMyRequestItemActionsBloc extends Bloc<
    ComfortMyRequestItemActionsEvent, ComfortMyRequestItemActionsState> {
  ComfortMyRequestItemActionsBloc()
      : super(const ComfortMyRequestItemActionsInitialState()) {
    on<ComfortMyRequestItemActionsEvent>((event, emit) {});
    on<ComfortMyRequestItemActionsLoadedEvent>((event, emit) {
      // Loading/Error/Success herdam de `...LoadedEvent`: sem esta guarda
      // este handler também rodaria para eles e emitiria um `LoadedState`
      // intermediário antes do estado específico.
      if (event.runtimeType != ComfortMyRequestItemActionsLoadedEvent) return;
      emit(ComfortMyRequestItemActionsLoadedState(event.request));
    });
    on<ComfortMyRequestItemActionsLoadingEvent>((event, emit) => emit(
        ComfortMyRequestItemActionsLoadingState(event.action, event.request)));
    on<ComfortMyRequestItemActionsErrorEvent>(
        (event, emit) => emit(ComfortMyRequestItemActionsErrorState(
              request: event.request,
              action: event.action,
              errorMessageKey: event.errorMessageKey,
              errorDescription: event.errorDescription,
              errorCode: event.errorCode,
            )));
    on<ComfortMyRequestItemActionsSuccessEvent>((event, emit) {
      emit(
          ComfortMyRequestItemActionsSuccessState(event.action, event.request));
    });
  }
}
