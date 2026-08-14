import 'package:flutter/foundation.dart';

import 'city_entity.dart';

class EasyFixUnit {
  final String? name;
  final String? cpfCnpj;
  final String email;
  final String cellphone;
  final String phone;
  final String cep;
  final String address;
  final String addressNumber;
  final String? addressComplement;
  final String addressNeighborhood;
  final String? addressState;
  final City? addressCity;

  EasyFixUnit({
    this.name,
    this.cpfCnpj,
    required this.email,
    required this.cellphone,
    required this.phone,
    required this.cep,
    required this.address,
    required this.addressNumber,
    this.addressComplement,
    required this.addressNeighborhood,
    this.addressState,
    this.addressCity,
  });

  EasyFixUnit copyWith({
    String? name,
    String? cpfCnpj,
    String? email,
    String? cellphone,
    String? phone,
    String? cep,
    String? address,
    String? addressNumber,
    String? addressComplement,
    String? addressNeighborhood,
    String? addressState,
    City? addressCity,
  }) {
    return EasyFixUnit(
      name: name ?? this.name,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      email: email ?? this.email,
      cellphone: cellphone ?? this.cellphone,
      phone: phone ?? this.phone,
      cep: cep ?? this.cep,
      address: address ?? this.address,
      addressNumber: addressNumber ?? this.addressNumber,
      addressComplement: addressComplement ?? this.addressComplement,
      addressNeighborhood: addressNeighborhood ?? this.addressNeighborhood,
      addressState: addressState ?? this.addressState,
      addressCity: addressCity ?? this.addressCity,
    );
  }

  @override
  String toString() {
    return 'name: $name, cpfCnpj: $cpfCnpj, email: $email, cellphone: $cellphone, phone: $phone, cep: $cep, address: $address, addressNumber: $addressNumber, addressComplement: $addressComplement, addressNeighborhood: $addressNeighborhood, addressState: $addressState, addressCity: $addressCity';
  }

  @visibleForTesting
  factory EasyFixUnit.filled() {
    return EasyFixUnit(
      email: "teste@gmail.com",
      cellphone: "998222044",
      phone: "32048116",
      cep: "72889644",
      address: "Avenida Nida",
      addressNumber: "124",
      addressNeighborhood: "Jardins",
    );
  }

  @override
  bool operator ==(covariant EasyFixUnit other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.cpfCnpj == cpfCnpj &&
        other.email == email &&
        other.cellphone == cellphone &&
        other.phone == phone &&
        other.cep == cep &&
        other.address == address &&
        other.addressNumber == addressNumber &&
        other.addressComplement == addressComplement &&
        other.addressNeighborhood == addressNeighborhood &&
        other.addressState == addressState &&
        other.addressCity == addressCity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        cpfCnpj.hashCode ^
        email.hashCode ^
        cellphone.hashCode ^
        phone.hashCode ^
        cep.hashCode ^
        address.hashCode ^
        addressNumber.hashCode ^
        addressComplement.hashCode ^
        addressNeighborhood.hashCode ^
        addressState.hashCode ^
        addressCity.hashCode;
  }
}
