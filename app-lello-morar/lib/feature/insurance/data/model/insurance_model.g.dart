// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceModel _$InsuranceModelFromJson(Map<String, dynamic> json) =>
    InsuranceModel(
      insuranceData: json['insurance_data'] == null
          ? null
          : InsuranceDataModel.fromJson(json['insurance_data']),
      insuranceStatus: json['insurance_status'] as String?,
      insuranceInfo: json['insurance_info'] == null
          ? null
          : InsuranceInfoModel.fromJson(json['insurance_info']),
    );

Map<String, dynamic> _$InsuranceModelToJson(InsuranceModel instance) =>
    <String, dynamic>{
      'insurance_data': instance.insuranceData,
      'insurance_status': instance.insuranceStatus,
      'insurance_info': instance.insuranceInfo,
    };
