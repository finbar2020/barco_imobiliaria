// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_occurrence_manual_appontment_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetOccurrenceManualAppontmentListModel
    _$TimesheetOccurrenceManualAppontmentListModelFromJson(
            Map<String, dynamic> json) =>
        TimesheetOccurrenceManualAppontmentListModel(
          times: (json['times'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
        );

Map<String, dynamic> _$TimesheetOccurrenceManualAppontmentListModelToJson(
        TimesheetOccurrenceManualAppontmentListModel instance) =>
    <String, dynamic>{
      'times': instance.times,
    };
