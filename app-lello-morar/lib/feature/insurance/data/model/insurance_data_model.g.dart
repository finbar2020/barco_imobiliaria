// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceDataModel _$InsuranceDataModelFromJson(Map<String, dynamic> json) =>
    InsuranceDataModel(
      name: json['name'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      idUnit: json['id_unit'] as String?,
      idInsurance: json['id_insurance'] as String?,
      flagJoin: json['flag_join'] as String?,
    );

Map<String, dynamic> _$InsuranceDataModelToJson(InsuranceDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'id_unit': instance.idUnit,
      'id_insurance': instance.idInsurance,
      'flag_join': instance.flagJoin,
    };
