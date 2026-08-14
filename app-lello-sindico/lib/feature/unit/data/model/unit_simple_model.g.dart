// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnitSimpleModel _$UnitSimpleModelFromJson(Map<String, dynamic> json) =>
    UnitSimpleModel(
      id: json['id'] as String,
      notificationContext: json['notification_context'] as String?,
      title: json['title'] as String,
    );

Map<String, dynamic> _$UnitSimpleModelToJson(UnitSimpleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification_context': instance.notificationContext,
      'title': instance.title,
    };
