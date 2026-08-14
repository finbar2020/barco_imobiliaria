// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_partner_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortPartnerDetailsModel _$ComfortPartnerDetailsModelFromJson(
        Map<String, dynamic> json) =>
    ComfortPartnerDetailsModel(
      id: json['id'] as String? ?? "",
      companyName: json['company_name'] as String? ?? "",
      cnpj: json['cnpj'] as String? ?? "",
    );

Map<String, dynamic> _$ComfortPartnerDetailsModelToJson(
        ComfortPartnerDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_name': instance.companyName,
      'cnpj': instance.cnpj,
    };
