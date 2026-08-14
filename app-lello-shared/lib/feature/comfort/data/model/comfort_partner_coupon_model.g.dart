// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_partner_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortPartnerCouponModel _$ComfortPartnerCouponModelFromJson(
        Map<String, dynamic> json) =>
    ComfortPartnerCouponModel(
      id: json['id'] as String? ?? "",
      code: json['code'] as String? ?? "",
      title: json['title'] as String? ?? "",
      discountPercentage: (json['discount_percentage'] as num?)?.toInt() ?? 0,
      highlight: json['highlight'] as bool? ?? false,
      description: json['description'] as String? ?? "",
      saleType: json['sale_type'] as String? ?? "",
      dateInsertion: json['date_insertion'] == null
          ? null
          : DateTime.parse(json['date_insertion'] as String),
      dateRemoval: json['date_removal'] == null
          ? null
          : DateTime.parse(json['date_removal'] as String),
      imageHash: json['image_hash'] as String? ?? "",
      reusable: json['reusable'] as bool? ?? true,
      useLimit: (json['use_limit'] as num?)?.toInt() ?? 999,
      notificationParameter: json['notification_parameter'] as String? ?? "",
    );

Map<String, dynamic> _$ComfortPartnerCouponModelToJson(
        ComfortPartnerCouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'title': instance.title,
      'discount_percentage': instance.discountPercentage,
      'highlight': instance.highlight,
      'description': instance.description,
      'sale_type': instance.saleType,
      'date_insertion': instance.dateInsertion?.toIso8601String(),
      'date_removal': instance.dateRemoval?.toIso8601String(),
      'image_hash': instance.imageHash,
      'reusable': instance.reusable,
      'use_limit': instance.useLimit,
      'notification_parameter': instance.notificationParameter,
    };
