// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_refused_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsRefusedModel _$AgreementsRefusedModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsRefusedModel(
      agreementsReprovedQtd: (json['agreements_reproved_qtd'] as num).toInt(),
      reportReprovedReason: (json['report_reproved_reason'] as List<dynamic>)
          .map((e) => AgreementsAnalysisElementModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      reportInstallments: (json['report_installments'] as List<dynamic>)
          .map((e) => AgreementsAnalysisElementModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      reportDueDate: (json['report_due_date'] as List<dynamic>)
          .map((e) => AgreementsAnalysisElementModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreementsRefusedModelToJson(
        AgreementsRefusedModel instance) =>
    <String, dynamic>{
      'agreements_reproved_qtd': instance.agreementsReprovedQtd,
      'report_reproved_reason': instance.reportReprovedReason,
      'report_installments': instance.reportInstallments,
      'report_due_date': instance.reportDueDate,
    };
