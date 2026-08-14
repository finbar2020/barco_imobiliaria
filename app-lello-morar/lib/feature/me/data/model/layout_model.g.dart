// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutModel _$LayoutModelFromJson(Map<String, dynamic> json) => LayoutModel(
      cod: json['cod'] as String? ?? "",
      name: json['name'] as String? ?? "",
      reference: json['reference'] as String? ?? "",
      primary: json['primary'] as String? ?? "",
      secondary: json['secondary'] as String? ?? "",
      logoPath: json['logo_path'] as String? ?? "",
    );

Map<String, dynamic> _$LayoutModelToJson(LayoutModel instance) =>
    <String, dynamic>{
      'cod': instance.cod,
      'name': instance.name,
      'reference': instance.reference,
      'primary': instance.primary,
      'secondary': instance.secondary,
      'logo_path': instance.logoPath,
    };
