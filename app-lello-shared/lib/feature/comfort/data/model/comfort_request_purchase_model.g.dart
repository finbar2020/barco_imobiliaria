// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_request_purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortRequestPurchaseModel _$ComfortRequestPurchaseModelFromJson(
        Map<String, dynamic> json) =>
    ComfortRequestPurchaseModel(
      requestId: json['request_id'] as String? ?? "",
      userId: json['user_id'] as String? ?? "",
      unitId: json['unit_id'] as String? ?? "",
      purchaseDone: json['purchase_done'] as bool? ?? false,
      usedCoupon: (json['used_coupon'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      purchaseDate: json['purchase_date'] == null
          ? null
          : DateTime.parse(json['purchase_date'] as String),
      dateResend: json['date_resend'] == null
          ? null
          : DateTime.parse(json['date_resend'] as String),
      typeCTA: json['type_c_t_a'] as String?,
      status: json['status'] as String?,
      canCancel: json['can_cancel'] as bool? ?? false,
      canResend: json['can_resend'] as bool? ?? false,
      typeSubject: json['type_subject'] as String?,
    );

Map<String, dynamic> _$ComfortRequestPurchaseModelToJson(
        ComfortRequestPurchaseModel instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'user_id': instance.userId,
      'unit_id': instance.unitId,
      'purchase_done': instance.purchaseDone,
      'used_coupon': instance.usedCoupon,
      'rating': instance.rating,
      'comment': instance.comment,
      'purchase_date': instance.purchaseDate?.toIso8601String(),
      'date_resend': instance.dateResend?.toIso8601String(),
      'type_c_t_a': instance.typeCTA,
      'can_cancel': instance.canCancel,
      'can_resend': instance.canResend,
      'status': instance.status,
      'type_subject': instance.typeSubject,
    };
