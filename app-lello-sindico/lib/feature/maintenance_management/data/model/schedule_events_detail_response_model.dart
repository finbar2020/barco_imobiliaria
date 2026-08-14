import 'package:essentials/essentials.dart';

part 'schedule_events_detail_response_model.g.dart';

/// Model for detailed schedule events API response
@JsonSerializable()
class ScheduleEventsDetailResponseModel {
  const ScheduleEventsDetailResponseModel({
    required this.success,
    required this.message,
    required this.data,
    this.errorCode,
    required this.legacyStatusCode,
  });

  final bool success;
  final String message;
  final ScheduleEventsDetailDataModel data;
  final String? errorCode;
  final int legacyStatusCode;

  factory ScheduleEventsDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$ScheduleEventsDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduleEventsDetailResponseModelToJson(this);
}

/// Data container model for schedule events
@JsonSerializable()
class ScheduleEventsDetailDataModel {
  const ScheduleEventsDetailDataModel({
    required this.taskSummaryDay,
    required this.taskFormulary,
    required this.obligations,
  });

  final TaskSummaryDayModel taskSummaryDay;
  final List<ScheduleEventTaskFormularyModel> taskFormulary;
  final List<ScheduleEventObligationModel> obligations;

  factory ScheduleEventsDetailDataModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventsDetailDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEventsDetailDataModelToJson(this);
}

@JsonSerializable()
class TaskSummaryDayModel {
  const TaskSummaryDayModel({
    required this.total,
    required this.done,
    required this.notStarted,
    required this.draft,
  });

  final int total;
  final int done;
  final int notStarted;
  final int draft;

  factory TaskSummaryDayModel.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskSummaryDayModelToJson(this);
}

@JsonSerializable()
class ScheduleEventTaskFormularyModel {
  const ScheduleEventTaskFormularyModel({
    this.timeDescription,
    this.timeStart,
    this.timeEnd,
    this.idTask,
    this.idSchedule,
    this.idScheduleEvent,
    this.typeTask,
    this.name,
    this.fullDescription,
    this.responsibleUserable,
    this.procedureGroupId,
    this.responsibleId,
    this.createdAt,
    this.dtstart,
    this.dtend,
    this.dtstartFormatted,
    this.dtendFormatted,
    this.status,
    this.rrule,
    this.effectiveDate,
    this.rruleDescription,
    this.allDay,
  });

  final String? timeDescription;
  final String? timeStart;
  final String? timeEnd;
  final String? idTask;
  final String? idSchedule;
  final String? idScheduleEvent;
  final String? typeTask;
  final String? name;
  final String? fullDescription;
  final String? responsibleUserable;
  final String? procedureGroupId;
  final String? responsibleId;
  final String? createdAt;
  final String? dtstart;
  final String? dtend;
  final String? dtstartFormatted;
  final String? dtendFormatted;
  final String? status;
  final String? rrule;
  final String? effectiveDate;
  final String? rruleDescription;
  final bool? allDay;

  factory ScheduleEventTaskFormularyModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventTaskFormularyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduleEventTaskFormularyModelToJson(this);
}

@JsonSerializable()
class ScheduleEventObligationModel {
  const ScheduleEventObligationModel({
    this.id,
    this.collectionCode,
    this.reference,
    this.partnerType,
    this.legalObligationType,
    this.name,
    this.expirationDescription,
    this.expirationDate,
    this.expirationStatus,
  });

  final String? id;
  final String? collectionCode;
  final int? reference;
  final String? partnerType;
  final String? legalObligationType;
  final String? name;
  final String? expirationDescription;
  final String? expirationDate;
  final String? expirationStatus;

  factory ScheduleEventObligationModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventObligationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleEventObligationModelToJson(this);
}
