// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumModel _$CondominiumModelFromJson(Map<String, dynamic> json) =>
    CondominiumModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      reference: json['reference'] as String? ?? "",
      jobPosition: json['job_position'] as String? ?? "",
      workShift: json['work_shift'] as String? ?? "",
      workLeaveDescription: json['work_leave_description'] as String? ?? "",
      shouldIgnoreDigitalPoint:
          json['should_ignore_digital_point'] as bool? ?? false,
      workShiftDetails: (json['work_shift_details'] as List<dynamic>?)
              ?.map((e) =>
                  WorkShiftDetailsModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      digitalTimesheetStatus: json['digital_timesheet_status'] as String?,
      usesDigitalTimesheet: json['uses_digital_timesheet'] as bool? ?? false,
      geographicCoordinates: json['geographic_coordinates'] == null
          ? null
          : GeographicCoordinatesModel.fromJson(
              json['geographic_coordinates'] as Map<String, dynamic>),
      digitalTimesheetDeviceAllowed:
          json['digital_timesheet_device_allowed'] as String? ?? 'all',
    );

Map<String, dynamic> _$CondominiumModelToJson(CondominiumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reference': instance.reference,
      'job_position': instance.jobPosition,
      'work_shift': instance.workShift,
      'work_leave_description': instance.workLeaveDescription,
      'should_ignore_digital_point': instance.shouldIgnoreDigitalPoint,
      'work_shift_details': instance.workShiftDetails,
      'digital_timesheet_status': instance.digitalTimesheetStatus,
      'uses_digital_timesheet': instance.usesDigitalTimesheet,
      'geographic_coordinates': instance.geographicCoordinates,
      'digital_timesheet_device_allowed':
          instance.digitalTimesheetDeviceAllowed,
    };
