import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/acess_type_enum.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

part 'building_manager_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BuildingManagerUserModel {
  String id;
  String name;
  String email;
  String phone;
  String cpf;
  AccessType? accessType;
  String? reference;
  bool isActive;
  bool isRegistered;
  bool usesFacialBiometrics;
  bool hasAppUsage;
  String? creatorUserId;
  String? gender;
  String? birthday;

  BuildingManagerUserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.cpf = "",
    this.accessType,
    this.reference,
    this.isActive = false,
    this.isRegistered = false,
    this.usesFacialBiometrics = false,
    this.hasAppUsage = false,
    this.creatorUserId,
    this.gender,
    this.birthday,
  });

  factory BuildingManagerUserModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingManagerUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingManagerUserModelToJson(this);

  static BuildingManagerUserModel? fromEntity(BuildingManagerUser? entity) =>
      entity == null
          ? null
          : (BuildingManagerUserModel()
            ..id = entity.id ?? ""
            ..name = entity.name ?? ""
            ..email = entity.email ?? ""
            ..phone = entity.phone ?? ""
            ..cpf = entity.cpf ?? ""
            ..accessType = entity.accessType
            ..reference = entity.reference
            ..isActive = entity.isActive ?? false
            ..isRegistered = entity.isRegistered ?? false
            ..usesFacialBiometrics = entity.usesFacialBiometrics ?? false
            ..hasAppUsage = entity.hasAppUsage ?? false
            ..creatorUserId = entity.creatorUserId
            ..gender = entity.gender
            ..birthday = entity.birthday);

  BuildingManagerUser toEntity() => BuildingManagerUser(
        id: id,
        name: name,
        email: email,
        phone: phone,
        cpf: cpf,
        accessType: accessType,
        reference: reference ?? "",
        isActive: isActive,
        isRegistered: isRegistered,
        usesFacialBiometrics: usesFacialBiometrics,
        hasAppUsage: hasAppUsage,
        creatorUserId: creatorUserId,
        gender: gender,
        birthday: birthday,
      );
}
