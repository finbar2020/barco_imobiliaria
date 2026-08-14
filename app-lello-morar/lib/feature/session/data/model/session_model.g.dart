// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel()
  ..me = json['me'] == null
      ? null
      : MeModel.fromJson(json['me'] as Map<String, dynamic>)
  ..unity = json['unity'] == null
      ? null
      : UnityModel.fromJson(json['unity'] as Map<String, dynamic>)
  ..condominium = json['condominium'] == null
      ? null
      : CondominiumModel.fromJson(json['condominium'] as Map<String, dynamic>);

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'me': instance.me,
      'unity': instance.unity,
      'condominium': instance.condominium,
    };
