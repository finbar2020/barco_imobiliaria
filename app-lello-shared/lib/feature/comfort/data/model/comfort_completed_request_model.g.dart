// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_completed_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortCompletedRequestModel _$ComfortCompletedRequestModelFromJson(
        Map<String, dynamic> json) =>
    ComfortCompletedRequestModel(
      idRequest: json['id_request'] as String? ?? "",
      dateRequest: json['date_request'] == null
          ? null
          : DateTime.parse(json['date_request'] as String),
      rating: (json['rating'] as num?)?.toDouble(),
      purchased: json['purchased'] as bool? ?? false,
      imageHash: json['image_hash'] as String? ?? "",
      comfortType: json['comfort_type'] as String? ?? "",
      partner: json['partner'] == null
          ? null
          : ComfortPartnerModel.fromJson(
              json['partner'] as Map<String, dynamic>),
      idPartner: json['id_partner'] as String? ?? "",
      isFavorite: json['is_favorite'] as bool? ?? false,
      isCanCancel: json['is_can_cancel'] as bool? ?? false,
      isCanResend: json['is_can_resend'] as bool? ?? false,
      resendDate: json['resend_date'] == null
          ? null
          : DateTime.parse(json['resend_date'] as String),
      comment: json['comment'] as String?,
      messageType: json['message_type'] as String?,
      status: json['status'] as String? ?? "sended",
      messageDate: json['message_date'] == null
          ? null
          : DateTime.parse(json['message_date'] as String),
      canceledDate: json['canceled_date'] == null
          ? null
          : DateTime.parse(json['canceled_date'] as String),
    );

Map<String, dynamic> _$ComfortCompletedRequestModelToJson(
        ComfortCompletedRequestModel instance) =>
    <String, dynamic>{
      'id_request': instance.idRequest,
      'date_request': instance.dateRequest?.toIso8601String(),
      'rating': instance.rating,
      'purchased': instance.purchased,
      'image_hash': instance.imageHash,
      'comfort_type': instance.comfortType,
      'partner': instance.partner,
      'id_partner': instance.idPartner,
      'is_favorite': instance.isFavorite,
      'is_can_cancel': instance.isCanCancel,
      'is_can_resend': instance.isCanResend,
      'resend_date': instance.resendDate?.toIso8601String(),
      'comment': instance.comment,
      'message_type': instance.messageType,
      'status': instance.status,
      'message_date': instance.messageDate?.toIso8601String(),
      'canceled_date': instance.canceledDate?.toIso8601String(),
    };
