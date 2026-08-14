import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import 'city_model.dart';

part 'easy_fix_unit_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EasyFixUnitModel {
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
  final CityModel? addressCity;

  EasyFixUnitModel({
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

  factory EasyFixUnitModel.fromEntity(EasyFixUnit entity) {
    return EasyFixUnitModel(
      name: entity.name,
      cellphone: entity.cellphone,
      cep: entity.cep,
      cpfCnpj: entity.cpfCnpj,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      addressCity: entity.addressCity != null
          ? CityModel.fromEntity(entity.addressCity!)
          : null,
      addressComplement: entity.addressComplement,
      addressNeighborhood: entity.addressNeighborhood,
      addressNumber: entity.addressNumber,
      addressState: entity.addressState,
    );
  }

  EasyFixUnit toEntity() {
    return EasyFixUnit(
      name: name,
      cellphone: cellphone,
      cep: cep,
      cpfCnpj: cpfCnpj,
      email: email,
      phone: phone,
      address: address,
      addressCity: addressCity?.toEntity(),
      addressComplement: addressComplement,
      addressNeighborhood: addressNeighborhood,
      addressNumber: addressNumber,
      addressState: addressState,
    );
  }

  factory EasyFixUnitModel.fromJson(Map<String, dynamic> json) =>
      _$EasyFixUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$EasyFixUnitModelToJson(this);
}
