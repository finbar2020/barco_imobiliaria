// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concierge_creator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConciergeCreator _$ConciergeCreatorFromJson(Map<String, dynamic> json) =>
    ConciergeCreator(
      name: json['name'] as String?,
      id: json['id'] as String?,
      type: $enumDecodeNullable(_$ConciergeCreatorTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ConciergeCreatorToJson(ConciergeCreator instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'type': _$ConciergeCreatorTypeEnumMap[instance.type],
    };

const _$ConciergeCreatorTypeEnumMap = {
  ConciergeCreatorType.appmorar: 'appmorar',
  ConciergeCreatorType.appsindico: 'appsindico',
  ConciergeCreatorType.portaria: 'portaria',
  ConciergeCreatorType.resolvafacil: 'resolvafacil',
  ConciergeCreatorType.moradorcriador: 'moradorcriador',
  ConciergeCreatorType.moradorcriadorsemlogin: 'moradorcriadorsemlogin',
};
