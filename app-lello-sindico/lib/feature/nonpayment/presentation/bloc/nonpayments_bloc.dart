import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_event.dart';
import 'package:lello/feature/nonpayment/presentation/bloc/nonpayments_state.dart';

class NonPaymentsBloc extends Bloc<NonPaymentsEvent, NonPaymentsState> {
  NonPaymentsBloc()
      : super(
          NonPaymentsEmptyState(),
        ) {
    on<NonPaymentsEmptyEvent>(handleNonPaymentsEmptyEvent);
    on<NonPaymentsLoadingEvent>(handleNonPaymentsLoadingEvent);
    on<NonPaymentsLoadFailedEvent>(handleNonPaymentsLoadFailedEvent);
    on<NonPaymentsLoadedEvent>(handleNonPaymentsLoadedEvent);
  }

  void handleNonPaymentsEmptyEvent(NonPaymentsEmptyEvent event, Emitter emit) {
    emit(
      NonPaymentsEmptyState(),
    );
  }

  void handleNonPaymentsLoadingEvent(
      NonPaymentsLoadingEvent event, Emitter emit) {
    emit(
      NonPaymentsLoadingState(),
    );
  }

  void handleNonPaymentsLoadFailedEvent(
      NonPaymentsLoadFailedEvent event, Emitter emit) {
    emit(
      NonPaymentsLoadFailedState(error: event.error),
    );
  }

  void handleNonPaymentsLoadedEvent(
      NonPaymentsLoadedEvent event, Emitter emit) {
    emit(
      NonPaymentsLoadedState(
          payments: event.payments, condominiumName: event.condominiumName),
    );
  }
}
