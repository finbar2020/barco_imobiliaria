import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

abstract class ReservationListEvent {}

class ReservationListLoadEvent extends ReservationListEvent {
  final String condominiumId;
  final ReservationType? type;
  final DateTime date;
  final String? spaceId;
  final ReservationFilter? filter;
  ReservationListLoadEvent({
    required this.condominiumId,
    this.type,
    required this.date,
    this.spaceId,
    this.filter,
  });
}

class ReservationListNextPageEvent extends ReservationListEvent {}
