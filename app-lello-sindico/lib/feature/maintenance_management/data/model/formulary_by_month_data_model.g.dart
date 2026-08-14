// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulary_by_month_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormularyByMonthDataModel _$FormularyByMonthDataModelFromJson(
        Map<String, dynamic> json) =>
    FormularyByMonthDataModel(
      name: json['name'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) =>
              FormularyDataPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FormularyByMonthDataModelToJson(
        FormularyByMonthDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
    };
