// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingRequestModel _$PendingRequestModelFromJson(Map<String, dynamic> json) =>
    PendingRequestModel(
      id: (json['id'] as num?)?.toInt(),
      typeOfLink: json['typeOfLink'] as String?,
      linkDescription: json['linkDescription'] as String?,
      requestStatus: json['requestStatus'] as String?,
      requestDate: json['requestDate'] == null
          ? null
          : DateTime.parse(json['requestDate'] as String),
      registrationOrigin: json['registrationOrigin'] as String?,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      unitId: (json['unitId'] as num?)?.toInt(),
      cpfCnpj: json['cpfCnpj'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      remainingDays: json['remainingDays'] as String?,
    );

Map<String, dynamic> _$PendingRequestModelToJson(
        PendingRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeOfLink': instance.typeOfLink,
      'linkDescription': instance.linkDescription,
      'requestStatus': instance.requestStatus,
      'requestDate': instance.requestDate?.toIso8601String(),
      'registrationOrigin': instance.registrationOrigin,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'unitId': instance.unitId,
      'cpfCnpj': instance.cpfCnpj,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'remainingDays': instance.remainingDays,
    };
