import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/domain/entity/address.dart';

part 'address_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddressModel {
  String? address;
  String? complement;
  String? number;

  AddressModel({this.complement, this.number});

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  static AddressModel? fromEntity(Address? entity) => entity == null
      ? null
      : (AddressModel()
        ..address = entity.address
        ..complement = entity.complement
        ..number = entity.number);

  Address toEntity() => Address()
    ..address = this.address
    ..complement = this.complement
    ..number = this.number;
}
