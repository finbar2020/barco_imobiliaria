// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';

import 'package:essentials/essentials.dart';

part 'resident_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResidentModel {
  final String? id;
  final String? typeAccess;
  final String? name;
  final String? cpf;
  final String? email;
  final String? accessControlBiometricStatus;
  final String? fixedPhone;
  final String? mobilePhone;
  final bool? useApp;
  final UnitModel? unit;

  ResidentModel({
    this.id,
    this.typeAccess,
    this.name,
    this.cpf,
    this.email,
    this.accessControlBiometricStatus,
    this.fixedPhone,
    this.mobilePhone,
    this.useApp,
    this.unit,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResidentModelToJson(this);

  static ResidentModel? fromEntity(Resident? entity) => entity == null
      ? null
      : (ResidentModel(
          id: entity.id,
          typeAccess: entity.typeAccess,
          name: entity.name,
          cpf: entity.cpf,
          email: entity.email,
          fixedPhone: entity.fixedPhone,
          mobilePhone: entity.mobilePhone,
          useApp: entity.useApp,
          accessControlBiometricStatus:
              enumToString(entity.accessControlBiometricStatus),
          unit: UnitModel.fromEntity(entity.unit),
        ));

  Resident toEntity() {
    return Resident(
      id: id,
      typeAccess: typeAccess,
      name: name,
      cpf: cpf,
      useApp: useApp,
      mobilePhone: mobilePhone,
      fixedPhone: fixedPhone,
      email: email,
      accessControlBiometricStatus: stringToEnum(
          AccessControlBiometricStatus.values, accessControlBiometricStatus),
      unit: unit?.toEntity(),
    );
  }

  ResidentModel copyWith({
    String? id,
    String? typeAccess,
    String? name,
    String? cpf,
    String? email,
    String? accessControlBiometricStatus,
    String? fixedPhone,
    String? mobilePhone,
    bool? useApp,
    UnitModel? unit,
  }) {
    return ResidentModel(
      id: id ?? this.id,
      typeAccess: typeAccess ?? this.typeAccess,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      accessControlBiometricStatus:
          accessControlBiometricStatus ?? this.accessControlBiometricStatus,
      fixedPhone: fixedPhone ?? this.fixedPhone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      useApp: useApp ?? this.useApp,
      unit: unit ?? this.unit,
    );
  }
}
