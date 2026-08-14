// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_ownership_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeOwnershipModel _$ChangeOwnershipModelFromJson(
        Map<String, dynamic> json) =>
    ChangeOwnershipModel(
      personType: json['person_type'] as String?,
      document: json['document'] as String?,
      registration: json['registration'] as String?,
      name: json['name'] as String?,
      sex: json['sex'] as String?,
      rg: json['rg'] as String?,
      date: json['date'] as String?,
      email: json['email'] as String?,
      nationality: json['nationality'] as String?,
      profession: json['profession'] as String?,
      maritalStatus: json['marital_status'] as String?,
      phone: json['phone'] as String?,
      cellphone: json['cellphone'] as String?,
      archives: (json['archives'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ChangeOwnershipModelToJson(
        ChangeOwnershipModel instance) =>
    <String, dynamic>{
      'person_type': instance.personType,
      'document': instance.document,
      'registration': instance.registration,
      'name': instance.name,
      'sex': instance.sex,
      'rg': instance.rg,
      'date': instance.date,
      'email': instance.email,
      'nationality': instance.nationality,
      'profession': instance.profession,
      'marital_status': instance.maritalStatus,
      'phone': instance.phone,
      'cellphone': instance.cellphone,
      'archives': instance.archives,
    };
