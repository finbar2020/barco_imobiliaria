// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accountability_recommendations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityRecommendationsModel _$AccountabilityRecommendationsModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityRecommendationsModel()
      ..name = json['name'] as String?
      ..date = json['date'] as String?
      ..isUser = json['is_user'] as bool?;

Map<String, dynamic> _$AccountabilityRecommendationsModelToJson(
        AccountabilityRecommendationsModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
      'is_user': instance.isUser,
    };
