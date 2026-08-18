import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_cancellation/reservation_cancellation_state.dart';

abstract class ReservationCancellationBloc
    extends Bloc<ReservationCancellationEvent, ReservationCancellationState> {
  ReservationCancellationBloc(ReservationCancellationState initialState)
      : super(initialState);

  void beginCancel(Reservation reservation);
}
