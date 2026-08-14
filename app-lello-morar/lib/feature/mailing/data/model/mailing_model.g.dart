// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mailing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MailingModel _$MailingModelFromJson(Map<String, dynamic> json) => MailingModel(
      id: json['id'] as String?,
      pickUpDate: json['pick_up_date'] == null
          ? null
          : DateTime.parse(json['pick_up_date'] as String),
      arrivalDate: json['arrival_date'] == null
          ? null
          : DateTime.parse(json['arrival_date'] as String),
      addressee: json['addressee'] as String?,
      category: json['category'] as String?,
      size: json['size'] as String?,
      status: json['status'] as String?,
      pickUpResident: json['pick_up_resident'] as String?,
      notificationParameter: json['notification_parameter'] as String?,
      photo: json['photo'] as String?,
      trackingCode: json['tracking_code'] as String?,
      description: json['description'] as String?,
      observation: json['observation'] as String?,
    );

Map<String, dynamic> _$MailingModelToJson(MailingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pick_up_date': instance.pickUpDate?.toIso8601String(),
      'arrival_date': instance.arrivalDate?.toIso8601String(),
      'addressee': instance.addressee,
      'category': instance.category,
      'size': instance.size,
      'status': instance.status,
      'pick_up_resident': instance.pickUpResident,
      'notification_parameter': instance.notificationParameter,
      'photo': instance.photo,
      'tracking_code': instance.trackingCode,
      'description': instance.description,
      'observation': instance.observation,
    };
