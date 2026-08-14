// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenRequestModel _$AccessTokenRequestModelFromJson(
        Map<String, dynamic> json) =>
    AccessTokenRequestModel(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$AccessTokenRequestModelToJson(
        AccessTokenRequestModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
