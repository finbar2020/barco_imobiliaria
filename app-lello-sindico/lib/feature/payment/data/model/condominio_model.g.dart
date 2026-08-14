// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominioModel _$CondominioModelFromJson(Map<String, dynamic> json) =>
    CondominioModel(
      cnpj: json['cnpj'] as String,
      idCondo: (json['id_condo'] as num).toInt(),
    );

Map<String, dynamic> _$CondominioModelToJson(CondominioModel instance) =>
    <String, dynamic>{
      'cnpj': instance.cnpj,
      'id_condo': instance.idCondo,
    };
