// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_review_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortReviewRequestModel _$ComfortReviewRequestModelFromJson(
        Map<String, dynamic> json) =>
    ComfortReviewRequestModel(
      requestId: json['request_id'] as String? ?? "",
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ComfortReviewRequestModelToJson(
        ComfortReviewRequestModel instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'rating': instance.rating,
      'comment': instance.comment,
    };
