// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';

class SubUser {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? cpf;
  final DateTime? expiresAt;
  final String? accessRenewalRequestStatus;
  final DateTime? accessRenewalRequestDate;
  final String? role;
  final String? roleDescription;
  final bool? blocked;
  final bool? useApp;
  final bool mainUser;
  final String? unitId;
  final String? picture;
  final File? pictureFile;
  final bool? registered;
  final String? notificationParameter;
  final bool? useFacialBiometric;
  final ConciergeCreator? creator;
  final bool? flagBoletoEmail;

  SubUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.expiresAt,
    this.role,
    this.accessRenewalRequestStatus,
    this.accessRenewalRequestDate,
    this.roleDescription,
    this.blocked,
    this.useApp,
    this.mainUser = false,
    this.unitId,
    this.picture,
    this.pictureFile,
    this.registered,
    this.notificationParameter,
    this.useFacialBiometric,
    this.creator,
    this.flagBoletoEmail,
  });

  bool isItself(String userID) {
    return userID == id;
  }

  SubUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? cpf,
    String? role,
    DateTime? accessRenewalRequestDate,
    String? roleDescription,
    bool? blocked,
    bool? useApp,
    DateTime? expiresAt,
    bool? mainUser,
    String? unitId,
    String? picture,
    File? pictureFile,
    bool? registered,
    String? notificationParameter,
    bool? useFacialBiometric,
    ConciergeCreator? creator,
    bool? flagBoletoEmail,
    String? accessRenewalRequestStatus,
  }) {
    return SubUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cpf: cpf ?? this.cpf,
      role: role ?? this.role,
      accessRenewalRequestDate:
          accessRenewalRequestDate ?? this.accessRenewalRequestDate,
      expiresAt: expiresAt,
      roleDescription: roleDescription ?? this.roleDescription,
      blocked: blocked ?? this.blocked,
      useApp: useApp ?? this.useApp,
      mainUser: mainUser ?? this.mainUser,
      unitId: unitId ?? this.unitId,
      picture: picture ?? this.picture,
      pictureFile: pictureFile ?? this.pictureFile,
      registered: registered ?? this.registered,
      flagBoletoEmail: flagBoletoEmail ?? this.flagBoletoEmail,
      notificationParameter:
          notificationParameter ?? this.notificationParameter,
      useFacialBiometric: useFacialBiometric ?? this.useFacialBiometric,
      creator: creator ?? this.creator,
      accessRenewalRequestStatus:
          accessRenewalRequestStatus ?? this.accessRenewalRequestStatus,
    );
  }

  String descriptionText(
    BuildContext context,
  ) {
    switch (creator?.type) {
      case ConciergeCreatorType.appmorar:
        return "${getString(context, "creator_vehicle")} ${creator?.name ?? ""}";
      case ConciergeCreatorType.appsindico:
        return getString(context, "creator_vehicle_sindico");
      case ConciergeCreatorType.portaria:
        return getString(context, "creator_vehicle_concierge");
      default:
        return "";
    }
  }
}
