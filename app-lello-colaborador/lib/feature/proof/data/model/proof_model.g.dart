// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProofModel _$ProofModelFromJson(Map<String, dynamic> json) => ProofModel(
      nsr: (json['nsr'] as num?)?.toInt(),
      dateTimeClockIn: json['date_time_clock_in'] as String,
      proofName: json['proof_name'] as String?,
    );

Map<String, dynamic> _$ProofModelToJson(ProofModel instance) =>
    <String, dynamic>{
      'nsr': instance.nsr,
      'date_time_clock_in': instance.dateTimeClockIn,
      'proof_name': instance.proofName,
    };
