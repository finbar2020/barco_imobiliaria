
import 'package:morar/feature/me/domain/entity/address.dart';

class CondoAddressDataEntity extends Address{
  final String zipCode;
  final String streetType;
  final String streetName;
  final String number;
  final String complement;
  final String cityName;
  final String state;
  final String neighborhood;

  CondoAddressDataEntity({
    required this.zipCode,
    required this.streetType,
    required this.streetName,
    required this.number,
    required this.complement,
    required this.cityName,
    required this.state,
    required this.neighborhood,
  });

  CondoAddressDataEntity copyWith({
    String? zipCode,
    String? streetType,
    String? streetName,
    String? number,
    String? complement,
    String? cityName,
    String? state,
    String? neighborhood,
  }) =>
      CondoAddressDataEntity(
        zipCode: zipCode ?? this.zipCode,
        streetType: streetType ?? this.streetType,
        streetName: streetName ?? this.streetName,
        number: number ?? this.number,
        complement: complement ?? this.complement,
        cityName: cityName ?? this.cityName,
        state: state ?? this.state,
        neighborhood: neighborhood ?? this.neighborhood,
      );

  factory CondoAddressDataEntity.fromJson(Map<String, dynamic> json) {
    return CondoAddressDataEntity(
      zipCode: json['cep'],
      streetType: json['tipoLogradouro'],
      streetName: json['nomeLogradouro'],
      number: json['numero'],
      complement: json['complemento'],
      cityName: json['nomeCidade'] ?? '',
      neighborhood: json['bairro'] ?? '',
      state: json['uf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': zipCode,
      'tipoLogradouro': streetType,
      'nomeLogradouro': streetName,
      'bairro': neighborhood,
      'numero': number,
      'complemento': complement,
      'nomeCidade': cityName,
      'uf': state,
    };
  }

  @override
  String toString() =>
      '$zipCode, $streetType $streetName, $number, ${neighborhood.isNotEmpty ? neighborhood + ', ' : ''}$cityName, $state';
}
