// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resin_person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResinPersonModel _$ResinPersonModelFromJson(Map<String, dynamic> json) =>
    ResinPersonModel(
      id: json['id'] as String? ?? "",
      document: json['document'] as String? ?? "",
      name: json['name'] as String? ?? "",
      role: json['role'] as String? ?? "",
    );

Map<String, dynamic> _$ResinPersonModelToJson(ResinPersonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'document': instance.document,
      'name': instance.name,
      'role': instance.role,
    };
