// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_analysis_element_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsAnalysisElementModel _$AgreementsAnalysisElementModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsAnalysisElementModel(
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$AgreementsAnalysisElementModelToJson(
        AgreementsAnalysisElementModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'value': instance.value,
      'percentage': instance.percentage,
    };
