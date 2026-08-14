// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiMetaModel _$ApiMetaModelFromJson(Map<String, dynamic> json) => ApiMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt(),
      totalPages: (json['total_pages'] as num?)?.toInt(),
      itemCount: (json['item_count'] as num?)?.toInt(),
      itemsPerPage: (json['items_per_page'] as num?)?.toInt(),
      totalItems: (json['total_items'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ApiMetaModelToJson(ApiMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_pages': instance.totalPages,
      'item_count': instance.itemCount,
      'items_per_page': instance.itemsPerPage,
      'total_items': instance.totalItems,
    };
