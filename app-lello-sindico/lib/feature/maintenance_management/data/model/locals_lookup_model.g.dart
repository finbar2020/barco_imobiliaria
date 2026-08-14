// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locals_lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalLookupModel _$LocalLookupModelFromJson(Map<String, dynamic> json) =>
    LocalLookupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      hierarchyLocals: json['hierarchy_locals'] as String,
    );

Map<String, dynamic> _$LocalLookupModelToJson(LocalLookupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hierarchy_locals': instance.hierarchyLocals,
    };

LocalsLookupModel _$LocalsLookupModelFromJson(Map<String, dynamic> json) =>
    LocalsLookupModel(
      locals: (json['locals'] as List<dynamic>)
          .map((e) => LocalLookupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocalsLookupModelToJson(LocalsLookupModel instance) =>
    <String, dynamic>{
      'locals': instance.locals,
    };
