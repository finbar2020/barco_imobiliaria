import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_event.dart';
import 'package:lello/feature/income/presentation/dasboard/bloc/income_dashboard_state.dart';

class IncomeDashboardBloc
    extends Bloc<IncomeDashboardEvent, IncomeDashboardState> {
  IncomeDashboardBloc() : super(IncomeDashboardLoadingState()) {
    on<IncomeDashboardSuccessEvent>(handleIncomeDashboardSuccessEvent);
    on<IncomeDashboardLoadingEvent>(handleIncomeDashboardLoadingEvent);
    on<IncomeDashboardFailureEvent>(handleIncomeDashboardFailureEvent);
  }

  void handleIncomeDashboardSuccessEvent(
      IncomeDashboardSuccessEvent event, Emitter emit) {
    emit(
      IncomeDashboardSuccessState(income: event.income),
    );
  }

  void handleIncomeDashboardLoadingEvent(
      IncomeDashboardLoadingEvent event, Emitter emit) {
    emit(
      IncomeDashboardLoadingState(),
    );
  }

  void handleIncomeDashboardFailureEvent(
      IncomeDashboardFailureEvent event, Emitter emit) {
    emit(
      IncomeDashboardFailureState(error: event.error),
    );
  }
}
