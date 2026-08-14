// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_proposals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsProposalsModel _$AgreementsProposalsModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsProposalsModel(
      agreements: (json['agreements'] as List<dynamic>)
          .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgreementsProposalsModelToJson(
        AgreementsProposalsModel instance) =>
    <String, dynamic>{
      'agreements': instance.agreements,
    };
