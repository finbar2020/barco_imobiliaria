import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';

part 'change_ownership_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChangeOwnershipModel {
  String? personType;
  String? document;
  String? registration;
  String? name;
  String? sex;
  String? rg;
  String? date;
  String? email;
  String? nationality;
  String? profession;
  String? maritalStatus;
  String? phone;
  String? cellphone;
  List<String>? archives;

  ChangeOwnershipModel({
    this.personType,
    this.document,
    this.registration,
    this.name,
    this.sex,
    this.rg,
    this.date,
    this.email,
    this.nationality,
    this.profession,
    this.maritalStatus,
    this.phone,
    this.cellphone,
    this.archives,
  });

  factory ChangeOwnershipModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeOwnershipModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeOwnershipModelToJson(this);

  static ChangeOwnershipModel fromEntity(OwnershipEntity entity) =>
      (ChangeOwnershipModel()
        ..personType = entity.personType
        ..document = entity.document
        ..registration = entity.registration
        ..name = entity.name
        ..sex = entity.sex
        ..rg = entity.rg
        ..date = entity.date
        ..email = entity.email
        ..nationality = entity.nationality
        ..profession = entity.profession
        ..maritalStatus = entity.maritalStatus
        ..phone = entity.phone
        ..cellphone = entity.cellphone
        ..archives = entity.archives);

  OwnershipEntity toEntity() => OwnershipEntity()
    ..personType = this.personType
    ..document = this.document
    ..registration = this.registration
    ..name = this.name
    ..sex = this.sex
    ..rg = this.rg
    ..date = this.date
    ..email = this.email
    ..nationality = this.nationality
    ..profession = this.profession
    ..maritalStatus = this.maritalStatus
    ..phone = this.phone
    ..cellphone = this.cellphone
    ..archives = this.archives ?? [];
}
