// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_occurrence_vacation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetOccurrenceVacationModel _$TimesheetOccurrenceVacationModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetOccurrenceVacationModel(
      numCra: json['num_cra'] as String? ?? "",
      name: json['name'] as String? ?? '',
      initDate: json['init_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      receiptUrl: json['receipt_url'] as String? ?? '',
      archiveName: json['archive_name'] as String? ?? '',
    );

Map<String, dynamic> _$TimesheetOccurrenceVacationModelToJson(
        TimesheetOccurrenceVacationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'num_cra': instance.numCra,
      'init_date': instance.initDate,
      'end_date': instance.endDate,
      'receipt_url': instance.receiptUrl,
      'archive_name': instance.archiveName,
    };
