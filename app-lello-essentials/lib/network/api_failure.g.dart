// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiFailure _$ApiFailureFromJson(Map<String, dynamic> json) => ApiFailure()
  ..status = (json['status'] as num?)?.toInt()
  ..title = json['title'] as String?
  ..detail = json['detail'] as String?
  ..type = json['type'] as String?
  ..instance = json['instance'] as String?
  ..failure = json['failure'] as String?
  ..message = json['message'] as String?;

Map<String, dynamic> _$ApiFailureToJson(ApiFailure instance) =>
    <String, dynamic>{
      'status': instance.status,
      'title': instance.title,
      'detail': instance.detail,
      'type': instance.type,
      'instance': instance.instance,
      'failure': instance.failure,
      'message': instance.message,
    };
