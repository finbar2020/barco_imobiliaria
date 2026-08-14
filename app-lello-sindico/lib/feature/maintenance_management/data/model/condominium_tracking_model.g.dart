// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumTrackingModel _$CondominiumTrackingModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumTrackingModel(
      idCondominiumTrackingTrade: json['idCondominiumTrackingTrade'] as String?,
      idCondominiumLello: (json['idCondominiumLello'] as num?)?.toInt(),
      reference: (json['reference'] as num?)?.toInt(),
      statusCondominium: json['statusCondominium'] as String?,
      condominiumName: json['condominiumName'] as String?,
      idUserTracking: json['idUserTracking'] as String?,
      idUserLello: (json['idUserLello'] as num?)?.toInt(),
      statusUser: json['statusUser'] as String?,
    );

Map<String, dynamic> _$CondominiumTrackingModelToJson(
        CondominiumTrackingModel instance) =>
    <String, dynamic>{
      'idCondominiumTrackingTrade': instance.idCondominiumTrackingTrade,
      'idCondominiumLello': instance.idCondominiumLello,
      'reference': instance.reference,
      'statusCondominium': instance.statusCondominium,
      'condominiumName': instance.condominiumName,
      'idUserTracking': instance.idUserTracking,
      'idUserLello': instance.idUserLello,
      'statusUser': instance.statusUser,
    };
