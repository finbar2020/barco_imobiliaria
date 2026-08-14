// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnityModel _$UnityModelFromJson(Map<String, dynamic> json) => UnityModel(
      id: json['id'] as String?,
      notificationContext: json['notification_context'] as String?,
      title: json['title'] as String?,
      rented: json['rented'] as bool?,
      compliant: json['compliant'] as bool?,
      agreement: json['agreement'] as bool?,
      termHomeToGo: json['term_home_to_go'] as bool?,
    );

Map<String, dynamic> _$UnityModelToJson(UnityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification_context': instance.notificationContext,
      'title': instance.title,
      'rented': instance.rented,
      'compliant': instance.compliant,
      'agreement': instance.agreement,
      'term_home_to_go': instance.termHomeToGo,
    };
