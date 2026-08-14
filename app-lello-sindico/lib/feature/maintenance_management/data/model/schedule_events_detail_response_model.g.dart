// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_events_detail_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleEventsDetailResponseModel _$ScheduleEventsDetailResponseModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventsDetailResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ScheduleEventsDetailDataModel.fromJson(
          json['data'] as Map<String, dynamic>),
      errorCode: json['errorCode'] as String?,
      legacyStatusCode: (json['legacyStatusCode'] as num).toInt(),
    );

Map<String, dynamic> _$ScheduleEventsDetailResponseModelToJson(
        ScheduleEventsDetailResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'errorCode': instance.errorCode,
      'legacyStatusCode': instance.legacyStatusCode,
    };

ScheduleEventsDetailDataModel _$ScheduleEventsDetailDataModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventsDetailDataModel(
      taskSummaryDay: TaskSummaryDayModel.fromJson(
          json['taskSummaryDay'] as Map<String, dynamic>),
      taskFormulary: (json['taskFormulary'] as List<dynamic>)
          .map((e) => ScheduleEventTaskFormularyModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      obligations: (json['obligations'] as List<dynamic>?)
              ?.map((e) => ScheduleEventObligationModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          <ScheduleEventObligationModel>[],
    );

Map<String, dynamic> _$ScheduleEventsDetailDataModelToJson(
        ScheduleEventsDetailDataModel instance) =>
    <String, dynamic>{
      'taskSummaryDay': instance.taskSummaryDay,
      'taskFormulary': instance.taskFormulary,
      'obligations': instance.obligations,
    };

TaskSummaryDayModel _$TaskSummaryDayModelFromJson(Map<String, dynamic> json) =>
    TaskSummaryDayModel(
      total: (json['total'] as num).toInt(),
      done: (json['done'] as num).toInt(),
      notStarted: (json['notStarted'] as num).toInt(),
      draft: (json['draft'] as num).toInt(),
    );

Map<String, dynamic> _$TaskSummaryDayModelToJson(
        TaskSummaryDayModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'done': instance.done,
      'notStarted': instance.notStarted,
      'draft': instance.draft,
    };

ScheduleEventTaskFormularyModel _$ScheduleEventTaskFormularyModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventTaskFormularyModel(
      timeDescription: json['timeDescription'] as String?,
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      idTask: json['idTask'] as String?,
      idSchedule: json['idSchedule'] as String?,
      idScheduleEvent: json['idScheduleEvent'] as String?,
      typeTask: json['typeTask'] as String?,
      name: json['name'] as String?,
      fullDescription: json['fullDescription'] as String?,
      responsibleUserable: json['responsibleUserable'] as String?,
      procedureGroupId: json['procedureGroupId'] as String?,
      responsibleId: json['responsibleId'] as String?,
      createdAt: json['createdAt'] as String?,
      dtstart: json['dtstart'] as String?,
      dtend: json['dtend'] as String?,
      dtstartFormatted: json['dtstartFormatted'] as String?,
      dtendFormatted: json['dtendFormatted'] as String?,
      status: json['status'] as String?,
      rrule: json['rrule'] as String?,
      effectiveDate: json['effectiveDate'] as String?,
      rruleDescription: json['rruleDescription'] as String?,
      allDay: json['allDay'] as bool?,
    );

Map<String, dynamic> _$ScheduleEventTaskFormularyModelToJson(
        ScheduleEventTaskFormularyModel instance) =>
    <String, dynamic>{
      'timeDescription': instance.timeDescription,
      'timeStart': instance.timeStart,
      'timeEnd': instance.timeEnd,
      'idTask': instance.idTask,
      'idSchedule': instance.idSchedule,
      'idScheduleEvent': instance.idScheduleEvent,
      'typeTask': instance.typeTask,
      'name': instance.name,
      'fullDescription': instance.fullDescription,
      'responsibleUserable': instance.responsibleUserable,
      'procedureGroupId': instance.procedureGroupId,
      'responsibleId': instance.responsibleId,
      'createdAt': instance.createdAt,
      'dtstart': instance.dtstart,
      'dtend': instance.dtend,
      'dtstartFormatted': instance.dtstartFormatted,
      'dtendFormatted': instance.dtendFormatted,
      'status': instance.status,
      'rrule': instance.rrule,
      'effectiveDate': instance.effectiveDate,
      'rruleDescription': instance.rruleDescription,
      'allDay': instance.allDay,
    };

ScheduleEventObligationModel _$ScheduleEventObligationModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleEventObligationModel(
      id: json['id'] as String?,
      collectionCode: json['collectionCode'] as String?,
      reference: (json['reference'] as num?)?.toInt(),
      partnerType: json['partnerType'] as String?,
      legalObligationType: json['legalObligationType'] as String?,
      name: json['name'] as String?,
      expirationDescription: json['expirationDescription'] as String?,
      expirationDate: json['expirationDate'] as String?,
      expirationStatus: json['expirationStatus'] as String?,
    );

Map<String, dynamic> _$ScheduleEventObligationModelToJson(
        ScheduleEventObligationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collectionCode': instance.collectionCode,
      'reference': instance.reference,
      'partnerType': instance.partnerType,
      'legalObligationType': instance.legalObligationType,
      'name': instance.name,
      'expirationDescription': instance.expirationDescription,
      'expirationDate': instance.expirationDate,
      'expirationStatus': instance.expirationStatus,
    };
