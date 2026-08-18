import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_state.dart';

abstract class ReservationFilterBloc
    extends Bloc<ReservationFilterEvent, ReservationFilterState> {
  ReservationFilterBloc(ReservationFilterState initialState)
      : super(initialState);
}
