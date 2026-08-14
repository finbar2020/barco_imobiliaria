// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_premium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsurancePremiumModel _$InsurancePremiumModelFromJson(
        Map<String, dynamic> json) =>
    InsurancePremiumModel(
      custo: (json['custo'] as num).toDouble(),
      valores: (json['valores'] as List<dynamic>)
          .map((e) =>
              InsurancePremiumValueModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InsurancePremiumModelToJson(
        InsurancePremiumModel instance) =>
    <String, dynamic>{
      'custo': instance.custo,
      'valores': instance.valores,
    };
