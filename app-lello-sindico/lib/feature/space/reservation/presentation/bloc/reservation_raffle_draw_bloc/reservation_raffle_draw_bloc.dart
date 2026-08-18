import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_state.dart';

abstract class ReservationRaffleDrawBloc
    extends Bloc<ReservationRaffleDrawEvent, ReservationRaffleDrawState> {
  ReservationRaffleDrawBloc(ReservationRaffleDrawState initialState)
      : super(initialState);

  void beginDraw();
  void beginLoad(String reservationId, String spaceId);
}
