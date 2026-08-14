// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_bank_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinBankModel _$ResinBankModelFromJson(Map<String, dynamic> json) =>
    ResinBankModel(
      id: json['id'] as String? ?? "",
      bankCode: json['bank_code'] as String? ?? "",
      bankName: json['bank_name'] as String? ?? "",
    );

Map<String, dynamic> _$ResinBankModelToJson(ResinBankModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank_code': instance.bankCode,
      'bank_name': instance.bankName,
    };
