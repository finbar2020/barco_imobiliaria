// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_enum.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import 'package:essentials/essentials.dart';

class Resident {
  final String? id;
  final String? typeAccess;
  final String? name;
  final String? cpf;
  final String? email;
  final Unit? unit;
  final String? fixedPhone;
  final String? mobilePhone;
  final bool? useApp;
  final AccessControlBiometricStatus? accessControlBiometricStatus;

  Resident({
    this.id,
    this.typeAccess,
    this.name,
    this.cpf,
    this.email,
    this.unit,
    this.fixedPhone,
    this.mobilePhone,
    this.useApp,
    this.accessControlBiometricStatus,
  });

  String? access(BuildContext context) {
    switch (typeAccess) {
      case "morar.proprietario":
        return getString(context, "residents_owner");
      case "morar.restrito":
        return getString(context, "residents_legal_representative");
      case "morar.parcial":
        return getString(context, "residents_underage");
      case "morar.morador":
        return getString(context, "residents_resident_info");
      case "morar.inquilino":
        return getString(context, "residents_tenant");
      default:
        null;
    }
    return null;
  }
}
