import 'dart:io';

class OwnershipEntity {
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
  List<String> archives;
  File? attachment;
  String? attachmentType;

  OwnershipEntity({
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
    this.archives = const [],
    this.attachment,
    this.attachmentType,
  });
}
