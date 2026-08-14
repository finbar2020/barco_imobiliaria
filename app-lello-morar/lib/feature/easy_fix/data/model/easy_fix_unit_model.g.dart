// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'easy_fix_unit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EasyFixUnitModel _$EasyFixUnitModelFromJson(Map<String, dynamic> json) =>
    EasyFixUnitModel(
      name: json['name'] as String?,
      cpfCnpj: json['cpf_cnpj'] as String?,
      email: json['email'] as String,
      cellphone: json['cellphone'] as String,
      phone: json['phone'] as String,
      cep: json['cep'] as String,
      address: json['address'] as String,
      addressNumber: json['address_number'] as String,
      addressComplement: json['address_complement'] as String?,
      addressNeighborhood: json['address_neighborhood'] as String,
      addressState: json['address_state'] as String?,
      addressCity: json['address_city'] == null
          ? null
          : CityModel.fromJson(json['address_city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EasyFixUnitModelToJson(EasyFixUnitModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cpf_cnpj': instance.cpfCnpj,
      'email': instance.email,
      'cellphone': instance.cellphone,
      'phone': instance.phone,
      'cep': instance.cep,
      'address': instance.address,
      'address_number': instance.addressNumber,
      'address_complement': instance.addressComplement,
      'address_neighborhood': instance.addressNeighborhood,
      'address_state': instance.addressState,
      'address_city': instance.addressCity,
    };
