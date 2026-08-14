// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timesheet_signature_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimesheetSignatureRequestModel _$TimesheetSignatureRequestModelFromJson(
        Map<String, dynamic> json) =>
    TimesheetSignatureRequestModel()
      ..signaturesRequest = (json['signatures_request'] as List<dynamic>?)
          ?.map((e) =>
              TimesheetSignatureModel.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$TimesheetSignatureRequestModelToJson(
        TimesheetSignatureRequestModel instance) =>
    <String, dynamic>{
      'signatures_request': instance.signaturesRequest,
    };
