import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';

part 'request_partners_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RequestPartnersModel {
  String? email;
  String? whatsapp;
  String? phone;
  List<String>? partners;
  RequestPartnersModel({
    this.email,
    this.whatsapp,
    this.phone,
    this.partners,
  });

  factory RequestPartnersModel.fromJson(Map<String, dynamic> json) =>
      _$RequestPartnersModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestPartnersModelToJson(this);

  static RequestPartnersModel? fromEntity(RequestPartnersEntity? entity) =>
      entity == null
          ? null
          : (RequestPartnersModel()
            ..email = entity.email
            ..whatsapp = entity.whatsapp
            ..phone = entity.phone
            ..partners = entity.partners);

  RequestPartnersEntity toEntity() => RequestPartnersEntity(
      email: this.email,
      whatsapp: this.whatsapp,
      phone: this.phone,
      partners: this.partners);
}
