// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacation_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacationRequestModel _$VacationRequestModelFromJson(
        Map<String, dynamic> json) =>
    VacationRequestModel()
      ..period = (json['period'] as num?)?.toInt()
      ..numberOfDays = (json['number_of_days'] as num?)?.toInt();

Map<String, dynamic> _$VacationRequestModelToJson(
        VacationRequestModel instance) =>
    <String, dynamic>{
      'period': instance.period,
      'number_of_days': instance.numberOfDays,
    };
