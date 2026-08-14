// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formulary_by_month_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormularyByMonthResponseModel _$FormularyByMonthResponseModelFromJson(
        Map<String, dynamic> json) =>
    FormularyByMonthResponseModel(
      formularyByMonthDto: (json['formularyByMonthDTO'] as List<dynamic>)
          .map((e) =>
              FormularyByMonthDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalConcluidos: (json['totalConcluidos'] as num).toInt(),
      totalNaoConcluidos: (json['totalNaoConcluidos'] as num).toInt(),
      totalGeral: (json['totalGeral'] as num).toInt(),
    );

Map<String, dynamic> _$FormularyByMonthResponseModelToJson(
        FormularyByMonthResponseModel instance) =>
    <String, dynamic>{
      'formularyByMonthDTO': instance.formularyByMonthDto,
      'totalConcluidos': instance.totalConcluidos,
      'totalNaoConcluidos': instance.totalNaoConcluidos,
      'totalGeral': instance.totalGeral,
    };
