// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billet_found_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletFoundModel _$BilletFoundModelFromJson(Map<String, dynamic> json) =>
    BilletFoundModel(
      description: json['description'] as String?,
      value: (json['value'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BilletFoundModelToJson(BilletFoundModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'value': instance.value,
    };
