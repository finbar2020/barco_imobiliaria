import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object?> get props => [];
}

class GetSpacesEvent extends ReservationEvent {
  const GetSpacesEvent();
}

class GetAllReservationEvent extends ReservationEvent {
  const GetAllReservationEvent();
}

class GetCalendarEvent extends ReservationEvent {
  final String spaceId;
  final DateTime startDate;
  final DateTime endDate;

  const GetCalendarEvent(
      {required this.spaceId, required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [spaceId, startDate, endDate];
}

class GetCalendarMonthEvent extends ReservationEvent {
  final String spaceId;
  final DateTime startDate;
  final DateTime endDate;

  const GetCalendarMonthEvent(
      {required this.spaceId, required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [spaceId, startDate, endDate];
}

class GetHoursEvent extends ReservationEvent {
  final String condominiumId;
  final String spaceId;
  final DateTime date;

  const GetHoursEvent(
      {required this.spaceId, required this.date, required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId, spaceId, date];
}

class PostFreeSpaceEvent extends ReservationEvent {
  final Space space;
  final DateTime reserveDate;
  final SpaceAvailableHours hour;

  const PostFreeSpaceEvent({
    required this.space,
    required this.reserveDate,
    required this.hour,
  });

  @override
  List<Object?> get props => [space, reserveDate, hour];
}

class PostReservationEvent extends ReservationEvent {
  final DateTime? reserveDate;
  final SpaceAvailableHours? hour;
  final ReservationRegistration model;

  const PostReservationEvent({
    required this.model,
    this.reserveDate,
    this.hour,
  });

  @override
  List<Object?> get props => [model, reserveDate, hour];
}

class DeleteReservationEvent extends ReservationEvent {
  final String reservationId;
  final String reservationType;
  final BuildContext context;

  const DeleteReservationEvent({
    required this.reservationId,
    required this.reservationType,
    required this.context,
  });

  @override
  List<Object?> get props => [reservationId, reservationType, context];
}

class ClearHoursEvent extends ReservationEvent {
  final DateTime date;

  const ClearHoursEvent({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}

class ClearErrorEvent extends ReservationEvent {
  final LoadedCalendarState state;

  const ClearErrorEvent({
    required this.state,
  });

  @override
  List<Object?> get props => [state];
}
