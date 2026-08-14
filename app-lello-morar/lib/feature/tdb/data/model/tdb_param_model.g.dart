// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tdb_param_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TDBParamModel _$TDBParamModelFromJson(Map<String, dynamic> json) =>
    TDBParamModel(
      type: json['type'] as String? ?? "",
      nameParam: json['name_param'] as String? ?? "",
      param: json['param'] as String? ?? "",
    );

Map<String, dynamic> _$TDBParamModelToJson(TDBParamModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name_param': instance.nameParam,
      'param': instance.param,
    };
