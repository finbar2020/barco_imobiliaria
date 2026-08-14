// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitModel _$UnitModelFromJson(Map<String, dynamic> json) => UnitModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      condominiumId: json['condominium_id'] as String?,
      group: json['group'] as String?,
      residentCount: (json['resident_count'] as num?)?.toInt(),
      vehicleCount: (json['vehicle_count'] as num?)?.toInt(),
      adimplente: json['adimplente'] as bool?,
      agreement: json['agreement'] as bool?,
      billingStatus: json['billing_status'] as String?,
      usesApp: json['uses_app'] as bool?,
      fixedPhone: json['fixed_phone'] as String?,
      mobilePhone: json['mobile_phone'] as String?,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnitModelToJson(UnitModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'condominium_id': instance.condominiumId,
      'group': instance.group,
      'resident_count': instance.residentCount,
      'vehicle_count': instance.vehicleCount,
      'adimplente': instance.adimplente,
      'agreement': instance.agreement,
      'billing_status': instance.billingStatus,
      'uses_app': instance.usesApp,
      'fixed_phone': instance.fixedPhone,
      'mobile_phone': instance.mobilePhone,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'vehicles': instance.vehicles,
    };
