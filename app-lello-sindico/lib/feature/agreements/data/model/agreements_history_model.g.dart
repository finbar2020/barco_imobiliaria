// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsHistoryModel _$AgreementsHistoryModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsHistoryModel(
      agreements: (json['agreements'] as List<dynamic>)
          .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreementsHistoryModelToJson(
        AgreementsHistoryModel instance) =>
    <String, dynamic>{
      'agreements': instance.agreements,
    };
