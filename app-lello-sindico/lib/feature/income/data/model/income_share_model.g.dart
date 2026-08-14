// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_share_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeShareModel _$IncomeShareModelFromJson(Map<String, dynamic> json) =>
    IncomeShareModel(
      title: json['title'] as String?,
      total: (json['total'] as num?)?.toInt(),
      share: (json['share'] as num?)?.toDouble(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$IncomeShareModelToJson(IncomeShareModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'total': instance.total,
      'share': instance.share,
      'color': instance.color,
    };
