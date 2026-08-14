// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_contract_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierContractModel _$SupplierContractModelFromJson(
        Map<String, dynamic> json) =>
    SupplierContractModel()
      ..id = (json['id'] as num?)?.toInt()
      ..code = json['code'] as String?;

Map<String, dynamic> _$SupplierContractModelToJson(
        SupplierContractModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
    };
