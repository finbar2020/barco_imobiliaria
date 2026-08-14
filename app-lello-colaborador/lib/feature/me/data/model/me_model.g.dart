// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeModel _$MeModelFromJson(Map<String, dynamic> json) => MeModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      cpf: json['cpf'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      picture: json['picture'] as String?,
      pictureHash: json['picture_hash'] as String?,
      condominiums: (json['condominiums'] as List<dynamic>?)
              ?.map((e) => CondominiumModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isTabletSession: json['is_tablet_session'] as bool? ?? false,
    );

Map<String, dynamic> _$MeModelToJson(MeModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'cpf': instance.cpf,
      'phone': instance.phone,
      'picture': instance.picture,
      'picture_hash': instance.pictureHash,
      'condominiums': instance.condominiums,
      'is_tablet_session': instance.isTabletSession,
    };
