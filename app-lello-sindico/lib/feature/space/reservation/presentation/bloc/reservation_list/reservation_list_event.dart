import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

abstract class ReservationListEvent extends Equatable {
  const ReservationListEvent();

  @override
  List<Object?> get props => [];
}

class ReservationListLoadEvent extends ReservationListEvent {
  final String condominiumId;
  final ReservationType? type;
  final DateTime date;
  final String? spaceId;
  final ReservationFilter? filter;

  const ReservationListLoadEvent({
    required this.condominiumId,
    this.type,
    required this.date,
    this.spaceId,
    this.filter,
  });

  @override
  List<Object?> get props => [condominiumId, type, date, spaceId, filter];
}

class ReservationListNextPageEvent extends ReservationListEvent {
  const ReservationListNextPageEvent();
}
