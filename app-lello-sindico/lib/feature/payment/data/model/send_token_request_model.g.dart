// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_token_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendTokenRequestModel _$SendTokenRequestModelFromJson(
        Map<String, dynamic> json) =>
    SendTokenRequestModel(
      method: json['method'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$SendTokenRequestModelToJson(
        SendTokenRequestModel instance) =>
    <String, dynamic>{
      'method': instance.method,
      'value': instance.value,
    };
