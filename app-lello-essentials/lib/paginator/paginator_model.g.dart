// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatorModel _$PaginatorModelFromJson(Map<String, dynamic> json) =>
    PaginatorModel(
      meta: json['meta'] == null
          ? null
          : MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      data: json['data'],
    );

Map<String, dynamic> _$PaginatorModelToJson(PaginatorModel instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'data': instance.data,
    };
