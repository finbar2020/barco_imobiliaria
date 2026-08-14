// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condo_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondoInfoModel _$CondoInfoModelFromJson(Map<String, dynamic> json) =>
    CondoInfoModel(
      reference: json['reference'] as String? ?? "",
      name: json['name'] as String? ?? "",
      picturehash: json['picturehash'] as String? ?? "",
      status: json['status'] as String? ?? "",
      ref: json['ref'] as String? ?? "",
    );

Map<String, dynamic> _$CondoInfoModelToJson(CondoInfoModel instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'name': instance.name,
      'picturehash': instance.picturehash,
      'status': instance.status,
      'ref': instance.ref,
    };
