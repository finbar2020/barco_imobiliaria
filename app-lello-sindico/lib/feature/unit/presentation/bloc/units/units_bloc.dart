import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lello/feature/unit/presentation/bloc/units/units_event.dart';
import 'package:lello/feature/unit/presentation/bloc/units/units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  UnitsBloc() : super(UnitsEmptyState()) {
    on<UnitsLoadingEvent>(handleUnitsLoadingEvent);
    on<UnitsEmptyEvent>(handleUnitsEmptyEvent);
    on<UnitsSuccessEvent>(handleUnitsSuccessEvent);
    on<UnitsFailureEvent>(handleUnitsFailureEvent);
    on<UnitsNewLoadingEvent>(handleUnitsNewLoadingEvent);
  }

  void handleUnitsLoadingEvent(UnitsLoadingEvent event, Emitter emit) {
    emit(UnitsLoadingState());
  }

  void handleUnitsNewLoadingEvent(UnitsNewLoadingEvent event, Emitter emit) {
    emit(UnitsNewLoadingState());
  }

  void handleUnitsEmptyEvent(UnitsEmptyEvent event, Emitter emit) {
    emit(UnitsEmptyState());
  }

  void handleUnitsSuccessEvent(UnitsSuccessEvent event, Emitter emit) {
    emit(UnitsSuccessState(units: event.units));
  }

  void handleUnitsFailureEvent(UnitsFailureEvent event, Emitter emit) {
    emit(UnitsFailureState(error: event.error));
  }
}
