import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_event.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_state.dart';

class TDBBloc extends Bloc {
  TDBBloc() : super(const LoadedTDBState()) {
    on<TDBLoadingEvent>(handleTDBLoadingEvent);
    on<TDBLoadedEvent>(handleTDBLoadedEvent);
    on<TDBErroEvent>(handleTDBErrorEvent);
  }

  void handleTDBLoadingEvent(TDBLoadingEvent event, Emitter emit) {
    emit(const LoadingTDBState());
  }

  void handleTDBLoadedEvent(TDBLoadedEvent event, Emitter emit) {
    emit(LoadedTDBState(tdbInfo: event.tdbInfo));
  }

  void handleTDBErrorEvent(TDBErroEvent event, Emitter emit) {
    emit(ErrorTDBState(errorMessageKey: event.errorMessageKey));
  }
}
