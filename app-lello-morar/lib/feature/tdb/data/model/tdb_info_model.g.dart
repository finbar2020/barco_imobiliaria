// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tdb_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TDBInfoModel _$TDBInfoModelFromJson(Map<String, dynamic> json) => TDBInfoModel(
      redirectLink: json['redirect_link'] as String? ?? "",
      information: (json['information'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : TDBParamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TDBInfoModelToJson(TDBInfoModel instance) =>
    <String, dynamic>{
      'redirect_link': instance.redirectLink,
      'information': instance.information,
    };
