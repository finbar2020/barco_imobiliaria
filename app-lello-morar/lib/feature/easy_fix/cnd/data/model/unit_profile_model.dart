import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';

part 'unit_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitProfileModel {
  final String email;
  final String mobilePhone;
  final String phone;

  UnitProfileModel({
    required this.email,
    required this.mobilePhone,
    required this.phone,
  });

  factory UnitProfileModel.fromEntity(UnitProfileEntity entity) {
    return UnitProfileModel(
      mobilePhone: entity.mobilePhone,
      email: entity.email,
      phone: entity.phone,
    );
  }

  UnitProfileEntity toEntity() {
    return UnitProfileEntity(
      mobilePhone: mobilePhone,
      email: email,
      phone: phone,
    );
  }

  factory UnitProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UnitProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnitProfileModelToJson(this);
}
