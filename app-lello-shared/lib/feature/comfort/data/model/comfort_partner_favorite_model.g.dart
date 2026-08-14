// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comfort_partner_favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComfortPartnerFavoriteModel _$ComfortPartnerFavoriteModelFromJson(
        Map<String, dynamic> json) =>
    ComfortPartnerFavoriteModel(
      comfortOwnerId: json['comfort_owner_id'] as String? ?? "",
      isFavorite: json['is_favorite'] as bool? ?? false,
    );

Map<String, dynamic> _$ComfortPartnerFavoriteModelToJson(
        ComfortPartnerFavoriteModel instance) =>
    <String, dynamic>{
      'comfort_owner_id': instance.comfortOwnerId,
      'is_favorite': instance.isFavorite,
    };
