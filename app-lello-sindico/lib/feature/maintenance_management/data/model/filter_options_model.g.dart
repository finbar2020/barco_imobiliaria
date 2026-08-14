// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterLocalModel _$FilterLocalModelFromJson(Map<String, dynamic> json) =>
    FilterLocalModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FilterLocalModelToJson(FilterLocalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

FilterAssetModel _$FilterAssetModelFromJson(Map<String, dynamic> json) =>
    FilterAssetModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FilterAssetModelToJson(FilterAssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

FilterResponsibleModel _$FilterResponsibleModelFromJson(
        Map<String, dynamic> json) =>
    FilterResponsibleModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FilterResponsibleModelToJson(
        FilterResponsibleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

FilterEmployeeGroupModel _$FilterEmployeeGroupModelFromJson(
        Map<String, dynamic> json) =>
    FilterEmployeeGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FilterEmployeeGroupModelToJson(
        FilterEmployeeGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

FilterOptionsModel _$FilterOptionsModelFromJson(Map<String, dynamic> json) =>
    FilterOptionsModel(
      locals: (json['locals'] as List<dynamic>)
          .map((e) => FilterLocalModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      assets: (json['assets'] as List<dynamic>)
          .map((e) => FilterAssetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      responsibles: (json['responsibles'] as List<dynamic>)
          .map(
              (e) => FilterResponsibleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeGroup: (json['employee_group'] as List<dynamic>)
          .map((e) =>
              FilterEmployeeGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilterOptionsModelToJson(FilterOptionsModel instance) =>
    <String, dynamic>{
      'locals': instance.locals,
      'assets': instance.assets,
      'responsibles': instance.responsibles,
      'employee_group': instance.employeeGroup,
    };
