// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumInfoModel _$CondominiumInfoModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumInfoModel(
      id: json['id'] as String,
      assets: (json['assets'] as num).toInt(),
      floor: json['floor'] as String,
      localsCount: (json['localsCount'] as num).toInt(),
      workflowUsers: json['workflowUsers'] as String,
      condominiumName: json['condominiumName'] as String,
      blocksCount: (json['blocksCount'] as num).toInt(),
      unitsCount: (json['unitsCount'] as num).toInt(),
      references: (json['references'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      condominium: json['condominium'] == null
          ? null
          : CondominiumTrackingModel.fromJson(
              json['condominium'] as Map<String, dynamic>),
      trackingTrade: json['trackingTrade'] == null
          ? null
          : TrackingTradeModel.fromJson(
              json['trackingTrade'] as Map<String, dynamic>),
      tokens: (json['tokens'] as List<dynamic>?)
          ?.map(
              (e) => MaintenanceTokenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasEmployee: json['hasEmployee'] as bool?,
      hasTechnicalInspection: json['hasTechnicalInspection'] as bool?,
    );

Map<String, dynamic> _$CondominiumInfoModelToJson(
        CondominiumInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assets': instance.assets,
      'floor': instance.floor,
      'localsCount': instance.localsCount,
      'workflowUsers': instance.workflowUsers,
      'condominiumName': instance.condominiumName,
      'blocksCount': instance.blocksCount,
      'unitsCount': instance.unitsCount,
      'references': instance.references,
      'condominium': instance.condominium?.toJson(),
      'trackingTrade': instance.trackingTrade?.toJson(),
      'tokens': instance.tokens?.map((e) => e.toJson()).toList(),
      'hasEmployee': instance.hasEmployee,
      'hasTechnicalInspection': instance.hasTechnicalInspection,
    };
