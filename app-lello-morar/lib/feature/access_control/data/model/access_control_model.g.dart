// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlModel _$AccessControlModelFromJson(Map<String, dynamic> json) =>
    AccessControlModel(
      idGest: json['id_gest'] as String?,
      name: json['name'] as String?,
      document: json['document'] as String?,
      business: json['business'] as String?,
      typeDocument: json['type_document'] as String?,
      foreignDocument: json['foreign_document'] as String?,
      type: json['type'],
      phone: json['phone'] as String?,
      statusBiometric: json['status_biometric'],
      gestUnits: (json['gest_units'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : AccessControlGestUnitsModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      notificationParameter: json['notification_parameter'] as String?,
    );

Map<String, dynamic> _$AccessControlModelToJson(AccessControlModel instance) =>
    <String, dynamic>{
      'id_gest': instance.idGest,
      'business': instance.business,
      'document': instance.document,
      'type_document': instance.typeDocument,
      'foreign_document': instance.foreignDocument,
      'name': instance.name,
      'phone': instance.phone,
      'status_biometric': instance.statusBiometric,
      'type': instance.type,
      'gest_units': instance.gestUnits,
      'notification_parameter': instance.notificationParameter,
    };
