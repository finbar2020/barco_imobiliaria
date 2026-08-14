import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationListState extends Equatable {
  final List<SpaceAvailableHours> data;
  final String? condominiumId;
  final ReservationType? type;
  final DateTime? date;
  final String? spaceId;
  final ReservationFilter? filter;

  const ReservationListState(this.data, this.condominiumId, this.type,
      this.date, this.spaceId, this.filter);

  @override
  List<Object?> get props =>
      [data, condominiumId, type, date, spaceId, filter];
}

class ReservationListLoadingState extends ReservationListState {
  const ReservationListLoadingState(
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

  const ReservationListLoadFailedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.error)
      : super(data, condominiumId, type, date, spaceId, filter);

  @override
  List<Object?> get props =>
      [data, condominiumId, type, date, spaceId, filter, error];
}

class ReservationListPagingState extends ReservationListState {
  const ReservationListPagingState(
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

  const ReservationListPageFailedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.error)
      : super(data, condominiumId, type, date, spaceId, filter);

  @override
  List<Object?> get props =>
      [data, condominiumId, type, date, spaceId, filter, error];
}

class ReservationListLoadedState extends ReservationListState {
  final bool donePaging;

  const ReservationListLoadedState(
      List<SpaceAvailableHours> data,
      String spaceId,
      String condominiumId,
      ReservationType type,
      DateTime date,
      ReservationFilter filter,
      this.donePaging)
      : super(data, condominiumId, type, date, spaceId, filter);

  @override
  List<Object?> get props =>
      [data, condominiumId, type, date, spaceId, filter, donePaging];
}
