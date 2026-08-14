import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/domain/entity/address.dart';

part 'address_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddressModel {
  String? bairro;
  String? number;
  String? complement;
  String? state;
  String? logradouro;
  String? cep;

  AddressModel();

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  static AddressModel? fromEntity(Address? entity) => entity == null
      ? null
      : (AddressModel()
        ..bairro = entity.bairro
        ..number = entity.number
        ..complement = entity.complement
        ..state = entity.state
        ..logradouro = entity.logradouro
        ..cep = entity.cep);

  Address toEntity() => Address()
    ..bairro = this.bairro
    ..number = this.number
    ..complement = this.complement
    ..state = this.state
    ..logradouro = this.logradouro
    ..cep = this.cep;
}
