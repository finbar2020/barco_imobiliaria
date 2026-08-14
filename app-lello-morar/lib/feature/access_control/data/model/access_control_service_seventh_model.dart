import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';

part 'access_control_service_seventh_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlServiceSeventhModel {
  bool condominiumActive;

  AccessControlServiceSeventhModel({
    this.condominiumActive = false,
  });

  factory AccessControlServiceSeventhModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccessControlServiceSeventhModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccessControlServiceSeventhModelToJson(this);

  static AccessControlServiceSeventhModel? fromEntity(
          AccessControlServiceSeventh? entity) =>
      entity == null
          ? null
          : AccessControlServiceSeventhModel(
              condominiumActive: entity.condominiumActive);

  AccessControlServiceSeventh toEntity() =>
      AccessControlServiceSeventh(condominiumActive: this.condominiumActive);
}
