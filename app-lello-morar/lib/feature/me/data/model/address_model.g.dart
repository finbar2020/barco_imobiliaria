// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel()
  ..bairro = json['bairro'] as String?
  ..number = json['number'] as String?
  ..complement = json['complement'] as String?
  ..state = json['state'] as String?
  ..logradouro = json['logradouro'] as String?
  ..cep = json['cep'] as String?;

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'bairro': instance.bairro,
      'number': instance.number,
      'complement': instance.complement,
      'state': instance.state,
      'logradouro': instance.logradouro,
      'cep': instance.cep,
    };
