// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerAccountModel _$LedgerAccountModelFromJson(Map<String, dynamic> json) =>
    LedgerAccountModel(
      id: (json['id'] as num?)?.toInt(),
      shortCode: (json['short_code'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$LedgerAccountModelToJson(LedgerAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'short_code': instance.shortCode,
      'name': instance.name,
    };
