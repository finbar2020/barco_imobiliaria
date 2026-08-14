import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_details.dart';

part 'comfort_partner_details_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortPartnerDetailsModel {
  String id;
  String companyName;
  String cnpj;

  ComfortPartnerDetailsModel({
    this.id = "",
    this.companyName = "",
    this.cnpj = "",
  });

  factory ComfortPartnerDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortPartnerDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortPartnerDetailsModelToJson(this);

  static ComfortPartnerDetailsModel? fromEntity(
          ComfortPartnerDetails? entity) =>
      entity == null
          ? null
          : (ComfortPartnerDetailsModel()
            ..id = entity.id
            ..companyName = entity.companyName
            ..cnpj = entity.cnpj);

  ComfortPartnerDetails toEntity() => ComfortPartnerDetails(
        id: this.id,
        companyName: this.companyName,
        cnpj: this.cnpj,
      );
}
