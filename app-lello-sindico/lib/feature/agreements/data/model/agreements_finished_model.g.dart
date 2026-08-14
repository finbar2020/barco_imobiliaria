// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_finished_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsFinishedModel _$AgreementsFinishedModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsFinishedModel(
      agreementsPerformedAutomaticallyQtd:
          (json['agreements_performed_automatically_qtd'] as num).toInt(),
      agreementsManuallyApprovedQtd:
          (json['agreements_manually_approved_qtd'] as num).toInt(),
      reportPaymentMethod: (json['report_payment_method'] as List<dynamic>?)
              ?.map((e) => AgreementsAnalysisElementModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      reportInstallments: (json['report_installments'] as List<dynamic>?)
              ?.map((e) => AgreementsAnalysisElementModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      reportDueDate: (json['report_due_date'] as List<dynamic>?)
              ?.map((e) => AgreementsAnalysisElementModel.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AgreementsFinishedModelToJson(
        AgreementsFinishedModel instance) =>
    <String, dynamic>{
      'agreements_performed_automatically_qtd':
          instance.agreementsPerformedAutomaticallyQtd,
      'agreements_manually_approved_qtd':
          instance.agreementsManuallyApprovedQtd,
      'report_payment_method': instance.reportPaymentMethod,
      'report_installments': instance.reportInstallments,
      'report_due_date': instance.reportDueDate,
    };
