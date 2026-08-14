// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_by_month_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskByMonthResponseModel _$TaskByMonthResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskByMonthResponseModel(
      formularyByMonthDto: (json['formularyByMonthDTO'] as List<dynamic>)
          .map((e) => TaskByMonthDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalConcluidos: (json['totalConcluidos'] as num).toInt(),
      totalNaoConcluidos: (json['totalNaoConcluidos'] as num).toInt(),
      totalGeral: (json['totalGeral'] as num).toInt(),
    );

Map<String, dynamic> _$TaskByMonthResponseModelToJson(
        TaskByMonthResponseModel instance) =>
    <String, dynamic>{
      'formularyByMonthDTO': instance.formularyByMonthDto,
      'totalConcluidos': instance.totalConcluidos,
      'totalNaoConcluidos': instance.totalNaoConcluidos,
      'totalGeral': instance.totalGeral,
    };
