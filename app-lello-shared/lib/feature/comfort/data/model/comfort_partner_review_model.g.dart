// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_partner_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortPartnerReviewModel _$ComfortPartnerReviewModelFromJson(
        Map<String, dynamic> json) =>
    ComfortPartnerReviewModel(
      image: json['image'] as String?,
      name: json['name'] as String?,
      review: (json['review'] as num).toDouble(),
      comment: json['comment'] as String?,
      reviewDate: json['review_date'] == null
          ? null
          : DateTime.parse(json['review_date'] as String),
      redirectImage: json['redirect_image'] as String?,
    );

Map<String, dynamic> _$ComfortPartnerReviewModelToJson(
        ComfortPartnerReviewModel instance) =>
    <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'review': instance.review,
      'comment': instance.comment,
      'review_date': instance.reviewDate?.toIso8601String(),
      'redirect_image': instance.redirectImage,
    };
