// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildTaskModel _$ChildTaskModelFromJson(Map<String, dynamic> json) =>
    ChildTaskModel(
      scheduleEventId: json['scheduleEventId'] as String?,
      originAnswer: json['originAnswer'] == null
          ? null
          : OriginAnswerModel.fromJson(
              json['originAnswer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildTaskModelToJson(ChildTaskModel instance) =>
    <String, dynamic>{
      'scheduleEventId': instance.scheduleEventId,
      'originAnswer': instance.originAnswer,
    };
