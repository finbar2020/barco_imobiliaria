// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_registration_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpaceRegistrationRequestModel _$SpaceRegistrationRequestModelFromJson(
        Map<String, dynamic> json) =>
    SpaceRegistrationRequestModel()
      ..id = json['id'] as String?
      ..space = json['space'] as String?
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$SpaceRegistrationRequestModelToJson(
        SpaceRegistrationRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space': instance.space,
      'date': instance.date?.toIso8601String(),
    };
