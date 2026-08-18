import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_state.dart';

abstract class ReservationListBloc
    extends Bloc<ReservationListEvent, ReservationListState> {
  ReservationListBloc(ReservationListState initialState) : super(initialState);

  void beginLoad(DateTime date, String spaceId);
  void beginRefresh();
  void beginLoadNextPage();
}
