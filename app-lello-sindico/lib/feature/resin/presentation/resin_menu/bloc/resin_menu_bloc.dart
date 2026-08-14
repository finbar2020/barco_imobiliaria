import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_event.dart';
import 'package:lello/feature/resin/presentation/resin_menu/bloc/resin_menu_state.dart';

class ResinMenuBloc extends Bloc<ResinMenuEvent, ResinMenuState> {
  ResinMenuBloc() : super(ResinMenuLoadingState()) {
    on<ResinMenuLoadingsEvent>(handleMenuLoadingEvent);
    on<ResinMenuLoadedEvent>(handleMenuLoadedEvent);
    on<ResinMenuErrorEvent>(handleMenuErrorEvent);
  }

  void handleMenuLoadingEvent(ResinMenuLoadingsEvent event, Emitter emit) =>
      emit(ResinMenuLoadingState());

  void handleMenuLoadedEvent(ResinMenuLoadedEvent event, Emitter emit) =>
      emit(ResinMenuLoadedState(params: event.params));

  void handleMenuErrorEvent(ResinMenuErrorEvent event, Emitter emit) =>
      emit(ResinMenuErrorState(errorMessageKey: event.errorMessageKey));
}
