// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_in_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsInProgressModel _$AgreementsInProgressModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsInProgressModel(
      agreements: (json['agreements'] as List<dynamic>)
          .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreementsInProgressModelToJson(
        AgreementsInProgressModel instance) =>
    <String, dynamic>{
      'agreements': instance.agreements,
    };
