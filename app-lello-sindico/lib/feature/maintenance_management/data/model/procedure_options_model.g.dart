// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirstResponsibleModel _$FirstResponsibleModelFromJson(
        Map<String, dynamic> json) =>
    FirstResponsibleModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$FirstResponsibleModelToJson(
        FirstResponsibleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProcedureOptionModel _$ProcedureOptionModelFromJson(
        Map<String, dynamic> json) =>
    ProcedureOptionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      titleKey: json['title_key'] as String?,
      description: json['description'] as String?,
      urlImage: json['url_image'] as String,
      procedureId: json['procedure_id'] as String?,
      procedureGroupId: json['procedure_group_id'] as String?,
      procedureGroup: json['procedure_group'],
      firstResponsible: json['first_responsible'] == null
          ? null
          : FirstResponsibleModel.fromJson(
              json['first_responsible'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProcedureOptionModelToJson(
        ProcedureOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'title_key': instance.titleKey,
      'description': instance.description,
      'url_image': instance.urlImage,
      'procedure_id': instance.procedureId,
      'procedure_group_id': instance.procedureGroupId,
      'procedure_group': instance.procedureGroup,
      'first_responsible': instance.firstResponsible,
    };

ProcedureOptionsModel _$ProcedureOptionsModelFromJson(
        Map<String, dynamic> json) =>
    ProcedureOptionsModel(
      procedureOptions: (json['procedure_options'] as List<dynamic>)
          .map((e) => ProcedureOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProcedureOptionsModelToJson(
        ProcedureOptionsModel instance) =>
    <String, dynamic>{
      'procedure_options': instance.procedureOptions,
    };
