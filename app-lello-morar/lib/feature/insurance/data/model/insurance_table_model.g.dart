// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceTableModel _$InsuranceTableModelFromJson(Map<String, dynamic> json) =>
    InsuranceTableModel(
      telefone: json['telefone'] as String,
      assistencia: json['assistencia'] as String,
      premio: (json['premio'] as List<dynamic>)
          .map((e) => InsurancePremiumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      titulos: Map<String, String>.from(json['titulos'] as Map),
    );

Map<String, dynamic> _$InsuranceTableModelToJson(
        InsuranceTableModel instance) =>
    <String, dynamic>{
      'telefone': instance.telefone,
      'assistencia': instance.assistencia,
      'premio': instance.premio,
      'titulos': instance.titulos,
    };
