// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportMetaModel _$ReportMetaModelFromJson(Map<String, dynamic> json) =>
    ReportMetaModel(
      currentPage: (json['current_page'] as num?)?.toInt(),
      totalPage: (json['total_page'] as num?)?.toInt(),
      itemCount: (json['item_count'] as num?)?.toInt(),
      itemsPerPage: (json['items_per_page'] as num?)?.toInt(),
      totalItems: (json['total_items'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReportMetaModelToJson(ReportMetaModel instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'total_page': instance.totalPage,
      'item_count': instance.itemCount,
      'items_per_page': instance.itemsPerPage,
      'total_items': instance.totalItems,
    };
