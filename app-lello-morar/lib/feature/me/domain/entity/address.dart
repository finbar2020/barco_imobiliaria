import 'package:morar/feature/me/data/model/address_model.dart';

class Address extends AddressModel {
  String? bairro;
  String? number;
  String? complement;
  String? state;
  String? logradouro;
  String? cep;

  Address(
      {this.bairro,
      this.number,
      this.complement,
      this.state,
      this.logradouro,
      this.cep});
}
