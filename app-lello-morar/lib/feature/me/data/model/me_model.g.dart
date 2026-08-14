// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeModel _$MeModelFromJson(Map<String, dynamic> json) => MeModel()
  ..name = json['name'] as String?
  ..id = json['id'] as String?
  ..email = json['email'] as String?
  ..cpf = json['cpf'] as String?
  ..phone = json['phone'] as String?
  ..picture = json['picture'] as String?
  ..pictureHash = json['picture_hash'] as String?
  ..biometricPictureHash = json['biometric_picture_hash'] as String?
  ..condominiums = (json['condominiums'] as List<dynamic>?)
      ?.map((e) => e == null
          ? null
          : CondominiumModel.fromJson(e as Map<String, dynamic>))
      .toList()
  ..lastUpdatedAt = json['last_updated_at'] == null
      ? null
      : DateTime.parse(json['last_updated_at'] as String)
  ..useFacialBiometric = json['use_facial_biometric'] as bool?;

Map<String, dynamic> _$MeModelToJson(MeModel instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'email': instance.email,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'picture': instance.picture,
      'picture_hash': instance.pictureHash,
      'biometric_picture_hash': instance.biometricPictureHash,
      'condominiums': instance.condominiums,
      'last_updated_at': instance.lastUpdatedAt?.toIso8601String(),
      'use_facial_biometric': instance.useFacialBiometric,
    };
