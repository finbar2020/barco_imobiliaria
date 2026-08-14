// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/staff_access_management/domain/entity/acess_type_enum.dart';

class BuildingManagerUser {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? cpf;
  AccessType? accessType;
  String? reference;
  bool? isActive;
  bool? isRegistered;
  bool? usesFacialBiometrics;
  bool? hasAppUsage;
  String? creatorUserId;
  String? gender;
  String? birthday;

  BuildingManagerUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.cpf,
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

  BuildingManagerUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? cpf,
    AccessType? accessType,
    String? reference,
    bool? isActive,
    bool? isRegistered,
    bool? usesFacialBiometrics,
    bool? hasAppUsage,
    String? creatorUserId,
    String? gender,
    String? birthday,
  }) {
    return BuildingManagerUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
      accessType: accessType ?? this.accessType,
      reference: reference ?? this.reference,
      isActive: isActive ?? this.isActive,
      isRegistered: isRegistered ?? this.isRegistered,
      usesFacialBiometrics: usesFacialBiometrics ?? this.usesFacialBiometrics,
      hasAppUsage: hasAppUsage ?? this.hasAppUsage,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
    );
  }
}
