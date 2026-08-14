// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallmentSupplierModel _$InstallmentSupplierModelFromJson(
        Map<String, dynamic> json) =>
    InstallmentSupplierModel()
      ..supplierId = (json['supplier_id'] as num?)?.toInt()
      ..supplierDocument = json['supplier_document'] as String?
      ..cellPhone = json['cell_phone'] as String?
      ..block = json['block'] as String?
      ..email = json['email'] as String?
      ..tradeName = json['trade_name'] as String?
      ..legalName = json['legal_name'] as String?
      ..phone1 = json['phone1'] as String?
      ..phone2 = json['phone2'] as String?;

Map<String, dynamic> _$InstallmentSupplierModelToJson(
        InstallmentSupplierModel instance) =>
    <String, dynamic>{
      'supplier_id': instance.supplierId,
      'supplier_document': instance.supplierDocument,
      'cell_phone': instance.cellPhone,
      'block': instance.block,
      'email': instance.email,
      'trade_name': instance.tradeName,
      'legal_name': instance.legalName,
      'phone1': instance.phone1,
      'phone2': instance.phone2,
    };
