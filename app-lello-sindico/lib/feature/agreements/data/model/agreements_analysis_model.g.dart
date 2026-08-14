// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsAnalysisModel _$AgreementsAnalysisModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsAnalysisModel(
      fromDate: DateTime.parse(json['from_date'] as String),
      toDate: DateTime.parse(json['to_date'] as String),
      reportApproved: json['report_approved'] == null
          ? null
          : AgreementsFinishedModel.fromJson(
              json['report_approved'] as Map<String, dynamic>),
      reportReproved: json['report_reproved'] == null
          ? null
          : AgreementsRefusedModel.fromJson(
              json['report_reproved'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreementsAnalysisModelToJson(
        AgreementsAnalysisModel instance) =>
    <String, dynamic>{
      'from_date': instance.fromDate.toIso8601String(),
      'to_date': instance.toDate.toIso8601String(),
      'report_approved': instance.reportApproved,
      'report_reproved': instance.reportReproved,
    };
