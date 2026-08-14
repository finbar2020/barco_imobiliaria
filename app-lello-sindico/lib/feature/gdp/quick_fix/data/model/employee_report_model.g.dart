// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeReportModel _$EmployeeReportModelFromJson(Map<String, dynamic> json) =>
    EmployeeReportModel()
      ..type = $enumDecodeNullable(_$EmployeeReportTypeEnumMap, json['type'])
      ..employee = json['employee'] == null
          ? null
          : EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) =>
              EmployeeReportItemModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..stabilityDescription = json['stability_description'] as String?
      ..stabilityEnd = json['stability_end'] == null
          ? null
          : DateTime.parse(json['stability_end'] as String)
      ..stabilityStart = json['stability_start'] == null
          ? null
          : DateTime.parse(json['stability_start'] as String);

Map<String, dynamic> _$EmployeeReportModelToJson(
        EmployeeReportModel instance) =>
    <String, dynamic>{
      'type': _$EmployeeReportTypeEnumMap[instance.type],
      'employee': instance.employee,
      'items': instance.items,
      'stability_description': instance.stabilityDescription,
      'stability_end': instance.stabilityEnd?.toIso8601String(),
      'stability_start': instance.stabilityStart?.toIso8601String(),
    };

const _$EmployeeReportTypeEnumMap = {
  EmployeeReportType.vacation: 'vacation',
  EmployeeReportType.termination: 'termination',
};
