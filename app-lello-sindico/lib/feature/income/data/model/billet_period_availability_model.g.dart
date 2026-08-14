// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billet_period_availability_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletPeriodsAvailabilityModel _$BilletPeriodsAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    BilletPeriodsAvailabilityModel(
      months: (json['months'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BilletPeriodsAvailabilityModelToJson(
        BilletPeriodsAvailabilityModel instance) =>
    <String, dynamic>{
      'months': instance.months,
    };
