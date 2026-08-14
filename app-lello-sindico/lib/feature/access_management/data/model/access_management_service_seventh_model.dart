import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/access_management/domain/entity/access_management_service_seventh.dart';

part 'access_management_service_seventh_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessManagementServiceSeventhModel {
  bool condominiumActive;

  AccessManagementServiceSeventhModel({
    this.condominiumActive = false,
  });

  factory AccessManagementServiceSeventhModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccessManagementServiceSeventhModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccessManagementServiceSeventhModelToJson(this);

  static AccessManagementServiceSeventhModel? fromEntity(
          AccessManagementServiceSeventh? entity) =>
      entity == null
          ? null
          : AccessManagementServiceSeventhModel(
              condominiumActive: entity.condominiumActive);

  AccessManagementServiceSeventh toEntity() =>
      AccessManagementServiceSeventh(condominiumActive: this.condominiumActive);
}
