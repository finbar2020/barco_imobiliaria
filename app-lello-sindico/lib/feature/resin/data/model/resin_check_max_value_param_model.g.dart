// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_check_max_value_param_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinCheckMaxValueParamModel _$ResinCheckMaxValueParamModelFromJson(
        Map<String, dynamic> json) =>
    ResinCheckMaxValueParamModel(
      canRequest: json['can_request'] as bool,
      message: json['message'] as String,
      emailSended: json['email_sended'] as bool,
    );

Map<String, dynamic> _$ResinCheckMaxValueParamModelToJson(
        ResinCheckMaxValueParamModel instance) =>
    <String, dynamic>{
      'can_request': instance.canRequest,
      'message': instance.message,
      'email_sended': instance.emailSended,
    };
