// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_occurrence_certificate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetOccurrenceCertificateModel
    _$TimesheetOccurrenceCertificateModelFromJson(Map<String, dynamic> json) =>
        TimesheetOccurrenceCertificateModel(
          numCra: json['num_cra'] as String? ?? "",
          name: json['name'] as String? ?? '',
          initDate: json['init_date'] as String? ?? '',
          endDate: json['end_date'] as String? ?? '',
          reference: json['reference'] as String? ?? '',
          archiveHash: json['archive_hash'] as String? ?? '',
        );

Map<String, dynamic> _$TimesheetOccurrenceCertificateModelToJson(
        TimesheetOccurrenceCertificateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'num_cra': instance.numCra,
      'init_date': instance.initDate,
      'end_date': instance.endDate,
      'reference': instance.reference,
      'archive_hash': instance.archiveHash,
    };
