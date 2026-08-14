// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetLookupModel _$AssetLookupModelFromJson(Map<String, dynamic> json) =>
    AssetLookupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameWithHierarchyLocals: json['nameWithHierarchyLocals'] as String?,
    );

Map<String, dynamic> _$AssetLookupModelToJson(AssetLookupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameWithHierarchyLocals': instance.nameWithHierarchyLocals,
    };

AssetsLookupModel _$AssetsLookupModelFromJson(Map<String, dynamic> json) =>
    AssetsLookupModel(
      assets: (json['assets'] as List<dynamic>)
          .map((e) => AssetLookupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssetsLookupModelToJson(AssetsLookupModel instance) =>
    <String, dynamic>{
      'assets': instance.assets,
    };
