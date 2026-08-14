import 'package:morar/feature/my_preferences/domain/entities/personal_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_addess_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_paperless_data_entity.dart';

import 'unit_contact_data_entity.dart';

class AccessData {
  final int personUnitId;
  final int? residentUnitId;
  final String? accessType;
  final bool? propagateOtherUnits;
  final bool? useUnitAddress;
  final PersonalDataEntity? personalData;
  final UnitDataEntity unitData;
  final UnitContactDataEntity unitContactData;
  final AddressDataEntity unitAddressData;
  final UnitPaperlessDataEntity unitPaperlessData;
  final AddressDataEntity? condoAddressData;

  AccessData({
    required this.personUnitId,
    required this.unitData,
    required this.useUnitAddress,
    required this.propagateOtherUnits,
    required this.unitContactData,
    required this.unitAddressData,
    required this.unitPaperlessData,
    this.condoAddressData,
    this.residentUnitId,
    this.accessType,
    this.personalData,
  });

  AccessData copyWith({
    int? personUnitId,
    int? residentUnitId,
    String? accessType,
    bool? useCondoAddress,
    bool? propagateOtherUnits,
    PersonalDataEntity? personalData,
    UnitDataEntity? unitData,
    UnitContactDataEntity? unitContactData,
    AddressDataEntity? unitAddressData,
    UnitPaperlessDataEntity? unitPaperlessData,
    AddressDataEntity? condoAddressData,
  }) =>
      AccessData(
        personUnitId: personUnitId ?? this.personUnitId,
        residentUnitId: residentUnitId ?? this.residentUnitId,
        propagateOtherUnits: propagateOtherUnits ?? this.propagateOtherUnits,
        accessType: accessType ?? this.accessType,
        useUnitAddress: useCondoAddress ?? this.useUnitAddress,
        personalData: personalData ?? this.personalData,
        unitData: unitData ?? this.unitData,
        unitContactData: unitContactData ?? this.unitContactData,
        unitAddressData: unitAddressData ?? this.unitAddressData,
        unitPaperlessData: unitPaperlessData ?? this.unitPaperlessData,
        condoAddressData: condoAddressData ?? this.condoAddressData,
      );

  factory AccessData.fromJson(Map<String, dynamic> json) {
    return AccessData(
      personUnitId: json['idUnidPessoa'],
      residentUnitId: json['idMoradorUnidade'] ?? 0,
      useUnitAddress: json['usarEnderecoCondominio'] ?? false,
      propagateOtherUnits: false,
      accessType: json['tipoAcesso'] ?? '',
      personalData: json['dadosPessoais'] == null
          ? PersonalDataEntity(cpf: '')
          : PersonalDataEntity.fromJson(json['dadosPessoais']),
      unitData: UnitDataEntity.fromJson(json['dadosUnidade']),
      unitContactData:
          UnitContactDataEntity.fromJson(json['dadosContatoUnidade']),
      unitAddressData: AddressDataEntity.fromJson(json['dadosEnderecoUnidade']),
      unitPaperlessData:
          UnitPaperlessDataEntity.fromJson(json['dadosPapelZeroUnidade']),
      condoAddressData: json.containsKey('dadosEnderecoCondominio')
          ? AddressDataEntity.fromJson(json['dadosEnderecoCondominio'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUnidPessoa': personUnitId,
      'idMoradorUnidade': residentUnitId,
      'tipoAcesso': accessType,
      'usarEnderecoCondominio': useUnitAddress,
      'propagarOutrasUnidades': propagateOtherUnits,
      'dadosPessoais': personalData,
      'dadosUnidade': unitData.toJson(),
      'dadosContatoUnidade': unitContactData.toJson(),
      'dadosEnderecoUnidade': unitAddressData.toJson(),
      'dadosPapelZeroUnidade': unitPaperlessData.toJson(),
      "dadosEnderecoCondominio": condoAddressData?.toJson(),
    };
  }
}

abstract class Address {}
