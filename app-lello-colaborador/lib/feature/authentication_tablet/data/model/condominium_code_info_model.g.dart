// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_code_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumCodeInfoModel _$CondominiumCodeInfoModelFromJson(
        Map<String, dynamic> json) =>
    CondominiumCodeInfoModel(
      condoCode: json['condo_code'] as String? ?? "",
      condominium: json['condominium'] == null
          ? null
          : CondoInfoModel.fromJson(
              json['condominium'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : EmployeeInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CondominiumCodeInfoModelToJson(
        CondominiumCodeInfoModel instance) =>
    <String, dynamic>{
      'condo_code': instance.condoCode,
      'condominium': instance.condominium,
      'employees': instance.employees,
    };
