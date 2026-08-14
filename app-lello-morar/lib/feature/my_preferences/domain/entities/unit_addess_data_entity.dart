class AddressDataEntity {
  final String zipCode;
  final String streetType;
  final String streetName;
  final String number;
  final String complement;
  final String cityName;
  final String state;
  final String neighborhood;

  AddressDataEntity({
    required this.zipCode,
    required this.streetType,
    required this.streetName,
    required this.number,
    required this.complement,
    required this.cityName,
    required this.state,
    required this.neighborhood,
  });

  AddressDataEntity copyWith({
    String? zipCode,
    String? streetType,
    String? streetName,
    String? number,
    String? complement,
    String? cityName,
    String? state,
    String? neighborhood,
  }) =>
      AddressDataEntity(
        zipCode: zipCode ?? this.zipCode,
        streetType: streetType ?? this.streetType,
        streetName: streetName ?? this.streetName,
        number: number ?? this.number,
        complement: complement ?? this.complement,
        cityName: cityName ?? this.cityName,
        state: state ?? this.state,
        neighborhood: neighborhood ?? this.neighborhood,
      );

  factory AddressDataEntity.fromJson(Map<String, dynamic> json) {
    return AddressDataEntity(
      zipCode: json['cep'],
      streetType: json['tipoLogradouro'],
      streetName: json['nomeLogradouro'],
      number: json['numero'],
      complement:
          json.containsKey('complemento') ? json['complemento'] ?? '' : '',
      cityName: json.containsKey('nomeCidade') ? json['nomeCidade'] ?? '' : '',
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
