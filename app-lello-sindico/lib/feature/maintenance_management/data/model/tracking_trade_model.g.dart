// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_trade_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingTradeModel _$TrackingTradeModelFromJson(Map<String, dynamic> json) =>
    TrackingTradeModel(
      id: json['id'] as String?,
      idSession: json['idSession'] as String?,
      username: json['username'] as String?,
      status: _trackingTradeStatusFromJson(json['status'] as String?),
      admin: json['admin'] as bool?,
      profileId: json['profileId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      deletedAt: json['deletedAt'] as String?,
      invitationId: json['invitationId'] as String?,
      lastPasswordUpdatedAt: json['lastPasswordUpdatedAt'] as String?,
    );

Map<String, dynamic> _$TrackingTradeModelToJson(TrackingTradeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idSession': instance.idSession,
      'username': instance.username,
      'status': _trackingTradeStatusToJson(instance.status),
      'admin': instance.admin,
      'profileId': instance.profileId,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'invitationId': instance.invitationId,
      'lastPasswordUpdatedAt': instance.lastPasswordUpdatedAt,
    };
