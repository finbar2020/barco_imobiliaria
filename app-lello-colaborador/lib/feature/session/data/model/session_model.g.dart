// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
      meModel: json['me_model'] == null
          ? null
          : MeModel.fromJson(json['me_model'] as Map<String, dynamic>),
      condominiumModel: json['condominium_model'] == null
          ? null
          : CondominiumModel.fromJson(
              json['condominium_model'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'me_model': instance.meModel,
      'condominium_model': instance.condominiumModel,
    };
