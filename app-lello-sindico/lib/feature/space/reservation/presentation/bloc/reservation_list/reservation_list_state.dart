import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationListState {
  final List<SpaceAvailableHours> data;
  final String? condominiumId;
  final ReservationType? type;
  final DateTime? date;
  final String? spaceId;
  final ReservationFilter? filter;

  ReservationListState(this.data, this.condominiumId, this.type, this.date,
      this.spaceId, this.filter);
}

class ReservationListLoadingState extends ReservationListState {
  ReservationListLoadingState(
      List<SpaceAvailableHours> data,
      String? spaceId,
      String? condominiumId,
      ReservationType? type,
      DateTime? date,
      ReservationFilter? filter)
      : super(data, condominiumId, type, date, spaceId, filter);
}

class ReservationListLoadFailedState extends ReservationListState {
  final Failure error;
  ReservationListLoadFailedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.error)
      : super(data, condominiumId, type, date, spaceId, filter);
}

class ReservationListPagingState extends ReservationListState {
  ReservationListPagingState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter)
      : super(data, condominiumId, type, date, spaceId, filter);
}

class ReservationListPageFailedState extends ReservationListState {
  final Failure error;
  ReservationListPageFailedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.error)
      : super(data, condominiumId, type, date, spaceId, filter);
}

class ReservationListLoadedState extends ReservationListState {
  final bool donePaging;
  ReservationListLoadedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.donePaging)
      : super(data, condominiumId, type, date, spaceId, filter);
}
