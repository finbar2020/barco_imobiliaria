// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_fornecedor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipoFornecedorModel _$TipoFornecedorModelFromJson(Map<String, dynamic> json) =>
    TipoFornecedorModel(
      idTipoFornecedor: (json['id_tipo_fornecedor'] as num?)?.toInt(),
      nomeTipoFornecedor: json['nome_tipo_fornecedor'] as String?,
      codigoTipoFornecedor: json['codigo_tipo_fornecedor'] as String?,
    );

Map<String, dynamic> _$TipoFornecedorModelToJson(
        TipoFornecedorModel instance) =>
    <String, dynamic>{
      'id_tipo_fornecedor': instance.idTipoFornecedor,
      'nome_tipo_fornecedor': instance.nomeTipoFornecedor,
      'codigo_tipo_fornecedor': instance.codigoTipoFornecedor,
    };
