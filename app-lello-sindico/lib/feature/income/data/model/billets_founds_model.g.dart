// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billets_founds_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletsFoundsModel _$BilletsFoundsModelFromJson(Map<String, dynamic> json) =>
    BilletsFoundsModel()
      ..description = json['description'] as String?
      ..value = (json['value'] as num?)?.toDouble();

Map<String, dynamic> _$BilletsFoundsModelToJson(BilletsFoundsModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'value': instance.value,
    };
