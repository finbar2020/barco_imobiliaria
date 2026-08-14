// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_partner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortPartnerModel _$ComfortPartnerModelFromJson(Map<String, dynamic> json) =>
    ComfortPartnerModel(
      id: json['id'] as String? ?? "",
      targetPublic: json['target_public'] as String? ?? "",
      title: json['title'] as String? ?? "",
      imageHash: json['image_hash'] as String? ?? "",
      clobContent: json['clob_content'] as String? ?? "",
      comfortType: json['comfort_type'] as String? ?? "",
      category: json['category'] as String? ?? "",
      email: json['email'] as String? ?? "",
      instagram: json['instagram'] as String? ?? "",
      instagramLink: json['instagram_link'] as String? ?? "",
      site: json['site'] as String? ?? "",
      cta: json['cta'] as String? ?? "",
      biggestDiscountPercentage:
          (json['biggest_discount_percentage'] as num?)?.toInt() ?? 0,
      redirect: json['redirect'] as String? ?? "",
      partnerCoupons: (json['partner_coupons'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : ComfortPartnerCouponModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingsNumber: (json['ratings_number'] as num?)?.toInt() ?? 0,
      favorite: json['favorite'] as bool? ?? false,
      categoryOrder: (json['category_order'] as num?)?.toDouble() ?? 0.0,
      partnerOrder: (json['partner_order'] as num?)?.toDouble() ?? 0.0,
      notificationParameter: json['notification_parameter'] as String? ?? "",
    )..partnerDetails = json['partner_details'] == null
        ? null
        : ComfortPartnerDetailsModel.fromJson(
            json['partner_details'] as Map<String, dynamic>);

Map<String, dynamic> _$ComfortPartnerModelToJson(
        ComfortPartnerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'target_public': instance.targetPublic,
      'title': instance.title,
      'image_hash': instance.imageHash,
      'clob_content': instance.clobContent,
      'email': instance.email,
      'instagram': instance.instagram,
      'instagram_link': instance.instagramLink,
      'site': instance.site,
      'comfort_type': instance.comfortType,
      'category': instance.category,
      'biggest_discount_percentage': instance.biggestDiscountPercentage,
      'redirect': instance.redirect,
      'cta': instance.cta,
      'partner_coupons': instance.partnerCoupons,
      'partner_details': instance.partnerDetails,
      'rating': instance.rating,
      'ratings_number': instance.ratingsNumber,
      'favorite': instance.favorite,
      'category_order': instance.categoryOrder,
      'partner_order': instance.partnerOrder,
      'notification_parameter': instance.notificationParameter,
    };
