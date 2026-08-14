import 'package:equatable/equatable.dart';

class ScheduleEventsDetailResponseEntity extends Equatable {
  const ScheduleEventsDetailResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    this.errorCode,
    required this.legacyStatusCode,
  });

  final bool success;
  final String message;
  final ScheduleEventsDetailDataEntity data;
  final String? errorCode;
  final int legacyStatusCode;

  @override
  List<Object?> get props => [
        success,
        message,
        data,
        errorCode,
        legacyStatusCode,
      ];
}

class ScheduleEventsDetailDataEntity extends Equatable {
  const ScheduleEventsDetailDataEntity({
    required this.taskSummaryDay,
    required this.obligations,
  });

  final List<ScheduleEventTaskSummaryDayEntity> taskSummaryDay;
  final List<ScheduleEventObligationEntity> obligations;

  @override
  List<Object?> get props => [taskSummaryDay, obligations];
}

class ScheduleEventTaskSummaryDayEntity extends Equatable {
  const ScheduleEventTaskSummaryDayEntity({
    required this.date,
    required this.taskFormulary,
  });

  final String date;
  final List<ScheduleEventTaskFormularyEntity> taskFormulary;

  @override
  List<Object?> get props => [date, taskFormulary];
}

class ScheduleEventTaskFormularyEntity extends Equatable {
  const ScheduleEventTaskFormularyEntity({
    required this.idSchedule,
    required this.idScheduleEvent,
    required this.name,
    required this.dtStart,
    required this.dtEnd,
    required this.allDay,
    required this.percentDone,
    required this.description,
    required this.procedureGroupLabel,
    required this.localsLabel,
    required this.createdAt,
    required this.effectiveDate,
    required this.updatedAt,
    required this.status,
    required this.rrule,
    required this.color,
    required this.icon,
    required this.timeStart,
    required this.timeEnd,
    required this.timeDescription,
    required this.typeTask,
  });

  final String idSchedule;
  final String idScheduleEvent;
  final String name;
  final String dtStart;
  final String dtEnd;
  final bool allDay;
  final String percentDone;
  final String description;
  final String procedureGroupLabel;
  final String localsLabel;
  final String createdAt;
  final String effectiveDate;
  final String updatedAt;
  final String status;
  final String rrule;
  final String color;
  final String icon;
  final String timeStart;
  final String timeEnd;
  final String timeDescription;
  final String typeTask;

  @override
  List<Object?> get props => [
        idSchedule,
        idScheduleEvent,
        name,
        dtStart,
        dtEnd,
        allDay,
        percentDone,
        description,
        procedureGroupLabel,
        localsLabel,
        createdAt,
        effectiveDate,
        updatedAt,
        status,
        rrule,
        color,
        icon,
        timeStart,
        timeEnd,
        timeDescription,
        typeTask,
      ];
}

class ScheduleEventObligationEntity extends Equatable {
  const ScheduleEventObligationEntity({
    required this.id,
    required this.collectionCode,
    required this.reference,
    required this.partnerType,
    required this.legalObligationType,
    required this.name,
    required this.expirationDescription,
    required this.expirationDate,
    required this.expirationStatus,
  });

  final String id;
  final String collectionCode;
  final int reference;
  final String partnerType;
  final String legalObligationType;
  final String name;
  final String expirationDescription;
  final String expirationDate;
  final String expirationStatus;

  @override
  List<Object?> get props => [
        id,
        collectionCode,
        reference,
        partnerType,
        legalObligationType,
        name,
        expirationDescription,
        expirationDate,
        expirationStatus,
      ];
}
