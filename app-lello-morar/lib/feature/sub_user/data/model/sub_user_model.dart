// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';

part 'sub_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubUserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? expiresAt;
  final DateTime? accessRenewalRequestDate;
  final String? cpf;
  final String? role;
  final String? roleDescription;
  final bool? blocked;
  final bool? useApp;
  final bool? mainUser;
  final String? unitId;
  final bool? registered;
  final bool? flagBoletoEmail;
  final String? notificationParameter;
  final String? accessRenewalRequestStatus;
  final bool? useFacialBiometric;
  final String? picture;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final File? pictureFile;
  final ConciergeCreator? creator;

  SubUserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.expiresAt,
    this.role,
    this.roleDescription,
    this.accessRenewalRequestDate,
    this.blocked,
    this.useApp,
    this.mainUser,
    this.unitId,
    this.registered,
    this.notificationParameter,
    this.useFacialBiometric,
    this.accessRenewalRequestStatus,
    this.picture,
    this.pictureFile,
    this.creator,
    this.flagBoletoEmail,
  });

  factory SubUserModel.fromJson(Map<String, dynamic> json) =>
      _$SubUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubUserModelToJson(this);

  static SubUserModel fromEntity(SubUser entity) {
    return SubUserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      cpf: entity.cpf,
      expiresAt: entity.expiresAt,
      role: entity.role,
      roleDescription: entity.roleDescription,
      blocked: entity.blocked,
      useApp: entity.useApp,
      mainUser: entity.mainUser,
      unitId: entity.unitId,
      registered: entity.registered,
      notificationParameter: entity.notificationParameter,
      useFacialBiometric: entity.useFacialBiometric,
      accessRenewalRequestDate: entity.accessRenewalRequestDate,
      creator: entity.creator,
      accessRenewalRequestStatus: entity.accessRenewalRequestStatus,
      picture: entity.picture,
      pictureFile: entity.pictureFile,
      flagBoletoEmail: entity.flagBoletoEmail,
    );
  }

  SubUser toEntity() {
    return SubUser(
      id: this.id,
      name: this.name,
      email: this.email,
      phone: this.phone,
      cpf: this.cpf,
      expiresAt: this.expiresAt,
      role: this.role,
      roleDescription: this.roleDescription,
      blocked: this.blocked,
      useApp: this.useApp,
      mainUser: this.mainUser ?? false,
      accessRenewalRequestDate: this.accessRenewalRequestDate,
      unitId: this.unitId,
      registered: this.registered,
      notificationParameter: this.notificationParameter,
      useFacialBiometric: this.useFacialBiometric,
      accessRenewalRequestStatus: this.accessRenewalRequestStatus,
      creator: this.creator,
      picture: this.picture,
      pictureFile: this.pictureFile,
      flagBoletoEmail: this.flagBoletoEmail,
    );
  }
}
