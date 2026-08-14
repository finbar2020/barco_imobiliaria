// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_month_resume_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetMonthResumeModel _$TimesheetMonthResumeModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetMonthResumeModel(
      extraHours: (json['extra_hours'] as num?)?.toInt() ?? 0,
      delays: (json['delays'] as num?)?.toInt() ?? 0,
      vacations: (json['vacations'] as num?)?.toInt() ?? 0,
      fouls: (json['fouls'] as num?)?.toInt() ?? 0,
      extraHoursHundred: (json['extra_hours_hundred'] as num?)?.toInt() ?? 0,
      otherExtraHours: (json['other_extra_hours'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TimesheetMonthResumeModelToJson(
        TimesheetMonthResumeModel instance) =>
    <String, dynamic>{
      'extra_hours': instance.extraHours,
      'delays': instance.delays,
      'vacations': instance.vacations,
      'fouls': instance.fouls,
      'extra_hours_hundred': instance.extraHoursHundred,
      'other_extra_hours': instance.otherExtraHours,
    };
