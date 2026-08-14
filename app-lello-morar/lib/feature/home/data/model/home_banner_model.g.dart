// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeBannerModel _$HomeBannerModelFromJson(Map<String, dynamic> json) =>
    HomeBannerModel(
      insideApp: json['inside_app'] as bool?,
      image: json['image'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$HomeBannerModelToJson(HomeBannerModel instance) =>
    <String, dynamic>{
      'inside_app': instance.insideApp,
      'image': instance.image,
      'url': instance.url,
    };
