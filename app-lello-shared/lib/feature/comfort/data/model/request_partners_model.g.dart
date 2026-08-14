// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_partners_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestPartnersModel _$RequestPartnersModelFromJson(
        Map<String, dynamic> json) =>
    RequestPartnersModel(
      email: json['email'] as String?,
      whatsapp: json['whatsapp'] as String?,
      phone: json['phone'] as String?,
      partners: (json['partners'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RequestPartnersModelToJson(
        RequestPartnersModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'whatsapp': instance.whatsapp,
      'phone': instance.phone,
      'partners': instance.partners,
    };
