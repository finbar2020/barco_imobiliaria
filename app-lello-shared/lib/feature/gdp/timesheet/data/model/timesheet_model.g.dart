// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetModel _$TimesheetModelFromJson(Map<String, dynamic> json) =>
    TimesheetModel()
      ..employee = json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..time =
          (json['time'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..schedules = (json['schedules'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..justifications = (json['justifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..comments = json['comments'] as String?
      ..signature = json['signature'] as String?
      ..events =
          (json['events'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..eventControl = json['event_control'] == null
          ? null
          : TimesheetEventModel.fromJson(
              json['event_control'] as Map<String, dynamic>)
      ..lunchHours = (json['lunch_hours'] as num?)?.toInt()
      ..workedHours = (json['worked_hours'] as num?)?.toInt()
      ..extraHours50 = (json['extra_hours50'] as num?)?.toInt()
      ..extraHours60 = (json['extra_hours60'] as num?)?.toInt()
      ..extraHours75 = (json['extra_hours75'] as num?)?.toInt()
      ..extraHours80 = (json['extra_hours80'] as num?)?.toInt()
      ..extraHours100 = (json['extra_hours100'] as num?)?.toInt()
      ..extraHours140 = (json['extra_hours140'] as num?)?.toInt()
      ..extraHours200 = (json['extra_hours200'] as num?)?.toInt()
      ..lateHours = (json['late_hours'] as num?)?.toInt()
      ..earlyDepartureHours = (json['early_departure_hours'] as num?)?.toInt()
      ..statusDay = json['status_day'] as String?
      ..monthClosing = json['month_closing'] == null
          ? null
          : DateTime.parse(json['month_closing'] as String);

Map<String, dynamic> _$TimesheetModelToJson(TimesheetModel instance) =>
    <String, dynamic>{
      'employee': instance.employee,
      'date': instance.date?.toIso8601String(),
      'time': instance.time,
      'schedules': instance.schedules,
      'justifications': instance.justifications,
      'comments': instance.comments,
      'signature': instance.signature,
      'events': instance.events,
      'event_control': instance.eventControl,
      'lunch_hours': instance.lunchHours,
      'worked_hours': instance.workedHours,
      'extra_hours50': instance.extraHours50,
      'extra_hours60': instance.extraHours60,
      'extra_hours75': instance.extraHours75,
      'extra_hours80': instance.extraHours80,
      'extra_hours100': instance.extraHours100,
      'extra_hours140': instance.extraHours140,
      'extra_hours200': instance.extraHours200,
      'late_hours': instance.lateHours,
      'early_departure_hours': instance.earlyDepartureHours,
      'status_day': instance.statusDay,
      'month_closing': instance.monthClosing?.toIso8601String(),
    };
