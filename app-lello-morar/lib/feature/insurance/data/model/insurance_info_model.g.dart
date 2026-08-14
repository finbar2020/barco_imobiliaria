// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceInfoModel _$InsuranceInfoModelFromJson(Map<String, dynamic> json) =>
    InsuranceInfoModel(
      idProdutoCompl: json['id_produto_compl'] as String?,
      idProduto: json['id_produto'] as String?,
      saibaMais: json['saiba_mais'] as String?,
      ativo: json['ativo'] as bool?,
      termoDeUso: json['termo_de_uso'] as String?,
    );

Map<String, dynamic> _$InsuranceInfoModelToJson(InsuranceInfoModel instance) =>
    <String, dynamic>{
      'id_produto_compl': instance.idProdutoCompl,
      'id_produto': instance.idProduto,
      'saiba_mais': instance.saibaMais,
      'ativo': instance.ativo,
      'termo_de_uso': instance.termoDeUso,
    };
