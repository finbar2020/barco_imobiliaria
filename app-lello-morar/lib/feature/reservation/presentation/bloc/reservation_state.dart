import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

abstract class ReservationState {
  List<Space> spaces = [];
  Session? session;
  List<ReservationScheduled>? reservations;
  List<Space> get freeSpaces => spaces
      .where((element) =>
          !element.reservationRule.chargeable! && element.type!.id != "M")
      .toList();
  List<Space> get paidSpaces => spaces
      .where((element) =>
          element.reservationRule.chargeable! && element.type!.id != "M")
      .toList();
  List<Space> get movingSpaces =>
      spaces.where((element) => element.type!.id == "M").toList();
  ReservationState(this.spaces, this.session, this.reservations);
}

class ReservationEmptyState extends ReservationState {
  ReservationEmptyState(
      {List<Space> spaces = const [],
      Session? session,
      List<ReservationScheduled>? reservations})
      : super(spaces, session, reservations);
}

class LoadingSpaceState extends ReservationState {
  LoadingSpaceState(
      {List<Space> spaces = const [],
      Session? session,
      List<ReservationScheduled>? reservations})
      : super(spaces, session, reservations);
}

class LoadedSpaceState extends ReservationState {
  LoadedSpaceState(
      {List<Space> spaces = const [],
      required Session session,
      required List<ReservationScheduled> reservations})
      : super(spaces, session, reservations);
}

class FailureSpaceState extends ReservationState {
  FailureSpaceState(
      {List<Space> spaces = const [],
      Session? session,
      List<ReservationScheduled>? reservations})
      : super(spaces, session, reservations);
}

class LoadingCalendarState extends ReservationState {
  LoadingCalendarState(
      {List<Space> spaces = const [],
      required Session session,
      required List<ReservationScheduled> reservations})
      : super(spaces, session, reservations);
}

class LoadedCalendarState extends ReservationState {
  final DateTime stateCreatedAt = DateTime.now();
  SpaceCalendarResponse calendarResponse;
  List<SpaceAvailableHours> hours = [];
  DateTime selectedDate;
  bool loadedHours;
  final bool loadedMonth;
  Failure? error;
  LoadedCalendarState({
    required this.calendarResponse,
    List<Space> spaces = const [],
    required Session session,
    required List<ReservationScheduled> reservations,
    required this.selectedDate,
    this.hours = const [],
    this.loadedHours = true,
    this.loadedMonth = true,
    this.error,
  }) : super(spaces, session, reservations);
}

class FailureCalendarState extends ReservationState {
  FailureCalendarState(
      {List<Space> spaces = const [],
      required Session session,
      required List<ReservationScheduled> reservations})
      : super(spaces, session, reservations);
}

class LoadingDialogState extends ReservationState {
  SpaceCalendarResponse calendarResponse;
  List<SpaceAvailableHours> hours = [];
  final bool loadedHours;
  final bool loadedMonth;
  DateTime selectedDate;
  List<Space> spaces = [];
  Session? session;
  List<ReservationScheduled>? reservations;
  List<Space> get freeSpaces =>
      spaces.where((element) => !element.reservationRule.chargeable!).toList();
  List<Space> get paidSpaces =>
      spaces.where((element) => element.reservationRule.chargeable!).toList();
  LoadingDialogState({
    this.spaces = const [],
    this.session,
    this.reservations,
    required this.calendarResponse,
    required this.selectedDate,
    this.hours = const [],
    this.loadedHours = true,
    this.loadedMonth = true,
  }) : super(spaces, session, reservations);
}

class LoadedDialogState extends ReservationState {
  Space space;
  SpaceCalendarResponse calendarResponse;
  DateTime reserveDate;
  DateTime selectedDate;
  List<SpaceAvailableHours> hours = [];
  final bool loadedHours;
  final bool loadedMonth;
  final SpaceAvailableHours hour;
  final ReservationScheduled? reserva;
  bool isBillet;
  String? billetData;
  String? billetName;

  LoadedDialogState({
    List<Space> spaces = const [],
    required Session session,
    required List<ReservationScheduled> reservations,
    required this.space,
    required this.hour,
    required this.calendarResponse,
    required this.reserveDate,
    required this.selectedDate,
    this.hours = const [],
    this.loadedHours = true,
    this.loadedMonth = true,
    this.reserva,
    this.billetData,
    this.billetName,
    this.isBillet = false,
  }) : super(spaces, session, reservations);
}

class FailureDialogState extends ReservationState {
  SpaceCalendarResponse calendarResponse;
  List<SpaceAvailableHours> hours = [];
  final bool loadedHours;
  final bool loadedMonth;
  String? message;
  DateTime selectedDate;

  FailureDialogState({
    List<Space> spaces = const [],
    required Session session,
    required List<ReservationScheduled> reservations,
    required this.calendarResponse,
    required this.selectedDate,
    this.hours = const [],
    this.loadedHours = true,
    this.loadedMonth = true,
    this.message,
  }) : super(spaces, session, reservations);
}

class ReservationSendSuccessState extends ReservationState {
  ReservationScheduled reservation;
  Space? space;
  ReservationSendSuccessState(this.reservation, this.space,
      {List<Space> spaces = const [],
      Session? session,
      List<ReservationScheduled>? reservations})
      : super(spaces, session, reservations);
}

class ReservationDeletedState extends ReservationState {
  ReservationDeletedState(
      {List<Space> spaces = const [],
      required Session session,
      required List<ReservationScheduled> reservations})
      : super(spaces, session, reservations);
}
