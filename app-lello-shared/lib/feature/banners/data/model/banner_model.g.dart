// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      id: json['id'] as String,
      redirect: json['redirect'] as String?,
      redirectType: json['redirect_type'] as String?,
      name: json['name'] as String?,
      subTitle: json['sub_title'] as String?,
      observacao: json['observacao'] as String?,
      image: json['image'] as String,
      urlImage: json['url_image'] as String?,
      feature: json['feature'] as String?,
      location: json['location'] as String?,
      typeBanner: json['type_banner'] as String?,
      arg: json['arg'] == null
          ? null
          : BannerArgsModel.fromJson(json['arg'] as Map<String, dynamic>),
      projeto: json['projeto'] as String?,
      ordem: (json['ordem'] as num?)?.toInt(),
      ativo: json['ativo'] as String?,
      lastUpdateAt: json['last_update_at'] == null
          ? null
          : DateTime.parse(json['last_update_at'] as String),
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'redirect': instance.redirect,
      'redirect_type': instance.redirectType,
      'name': instance.name,
      'sub_title': instance.subTitle,
      'observacao': instance.observacao,
      'image': instance.image,
      'url_image': instance.urlImage,
      'feature': instance.feature,
      'location': instance.location,
      'type_banner': instance.typeBanner,
      'arg': instance.arg,
      'projeto': instance.projeto,
      'ordem': instance.ordem,
      'ativo': instance.ativo,
      'last_update_at': instance.lastUpdateAt?.toIso8601String(),
    };
