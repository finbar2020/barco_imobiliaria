// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_event.dart';
import 'package:lello/feature/income/presentation/billets/detail/bloc/billets_detail_state.dart';

class BilletsDetailBloc extends Bloc<BilletsDetailEvent, BilletsDetailState> {
  BilletsDetailBloc()
      : super(
          BilletsDetailEmptyState(),
        ) {
    on<BilletsDetailEmptyEvent>(handleBilletsDetailEmptyEvent);
    on<BilletsDetailLoadingEvent>(handleBilletsDetailLoadingEvent);
    on<BilletsDetailSuccessEvent>(handleBilletsDetailSuccessEvent);
    on<BilletsDetailFailureEvent>(handleBilletsDetailFailureEvent);
  }

  void handleBilletsDetailEmptyEvent(
      BilletsDetailEmptyEvent event, Emitter emit) {
    emit(BilletsDetailEmptyState());
  }

  void handleBilletsDetailLoadingEvent(
      BilletsDetailLoadingEvent event, Emitter emit) {
    emit(BilletsDetailLoadingState());
  }

  void handleBilletsDetailSuccessEvent(
      BilletsDetailSuccessEvent event, Emitter emit) {
    emit(BilletsDetailSuccessState(billet: event.billet));
  }

  void handleBilletsDetailFailureEvent(
      BilletsDetailFailureEvent event, Emitter emit) {
    emit(BilletsDetailFailureState(error: event.failure));
  }
}
