// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) => StatusModel(
      idStatus: (json['id_status'] as num?)?.toInt(),
      descricaoStatus: json['descricao_status'] as String?,
      flagStatus: json['flag_status'],
      listStatusTipoStatusVO:
          json['list_status_tipo_status_v_o'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'id_status': instance.idStatus,
      'descricao_status': instance.descricaoStatus,
      'flag_status': instance.flagStatus,
      'list_status_tipo_status_v_o': instance.listStatusTipoStatusVO,
    };
