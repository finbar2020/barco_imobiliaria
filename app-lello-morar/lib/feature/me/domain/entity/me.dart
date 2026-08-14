import 'dart:convert';
import 'dart:typed_data';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/me/domain/entity/block.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

class Me {
  String? name;
  String? id;
  String? email;
  String? cpf;
  String? phone;
  String? _picture;
  String? pictureHash;
  String? biometricPictureHash;
  List<Condominium>? condominiums;
  bool? useFacialBiometric;

  Uint8List? _pictureBytes;
  //File _pictureFile;

  DateTime? lastUpdatedAt;

  Me();

  factory Me.clone(Me me) => Me()
    ..name = me.name
    ..id = me.id
    ..email = me.email
    ..cpf = me.cpf
    ..phone = me.phone
    ..picture = me.picture
    ..condominiums = me.condominiums?.map((e) => Condominium.clone(e)).toList()
    ..lastUpdatedAt = me.lastUpdatedAt
    ..pictureHash = me.pictureHash
    ..biometricPictureHash = me.biometricPictureHash
    ..useFacialBiometric = me.useFacialBiometric ?? false;

  String getGreetings(BuildContext context, Me? me) {
    var firstName = me != null && me.name?.split(" ")[0] != null
        ? me.name?.split(" ")[0]
        : " ";
    var greeting =
        "${getString(context, "hi")}, ${firstName![0].toUpperCase()}${firstName.substring(1).toLowerCase()}";
    return greeting;
  }

  Me copyWith({
    String? name,
    String? id,
    String? email,
    String? cpf,
    String? phone,
    String? picture,
    List<Condominium>? condominiums,
    bool? useFacialBiometric,
    bool? showExpirationDialog,
  }) {
    return Me()
      ..name = name ?? this.name
      ..id = id ?? this.id
      ..email = email ?? this.email
      ..cpf = cpf ?? this.cpf
      ..phone = phone ?? this.phone
      ..picture = picture ?? this.picture
      ..condominiums = condominiums ?? this.condominiums;
  }

  List<List<dynamic>> get allUnits {
    List<List> units = [];
    List<String> references = [];
    condominiums!.map((Condominium e) {
      final cond = e;
      final blockstest = e.blocks!.map((Block e) {
        final unitTest = e.units!.map((e) {
          units.add([cond, e]);
          references.add(e.id!);
        }).toList();

        return unitTest;
      }).toList();
      return blockstest;
    }).toList();
    return units;
  }

  List<String> get allUnitIds {
    List<String> references = [];
    condominiums!.map((Condominium e) {
      final blockstest = e.blocks!.map((Block e) {
        final unitTest = e.units!.map((e) {
          references.add(e.id!);
        }).toList();

        return unitTest;
      }).toList();
      return blockstest;
    }).toList();
    return references;
  }

  List<Unity> get allUnitsEntity {
    List<Unity> units = [];
    condominiums!.map((Condominium e) {
      e.blocks?.map((Block e) {
        if (e.units?.isNotEmpty == true) units.addAll(e.units!);
      }).toList();
    }).toList();
    return units;
  }

  set picture(String? picture) {
    _picture = picture;
    _pictureBytes = base64.decode(picture ?? "");
    image = MemoryImage(_pictureBytes!);
  }

  String? get picture {
    return _picture;
  }

  MemoryImage? image;

  bool get hasToUpdate =>
      DateTime.now().difference(lastUpdatedAt!).inMinutes > 1;

  bool get hasImage => (_pictureBytes != null && _pictureBytes!.length > 0);

  String get pictureLink =>
      pictureHash?.isNotEmpty == true ? "/me/pictures/file/$pictureHash" : "";

  String? get biometriaImageLink => biometricPictureHash != null
      ? "/concierge/accesscontrol/pictures/file/$biometricPictureHash"
      : null;

  bool get isEmpty => cpf == null || cpf!.isEmpty;

  static Me empty() {
    return Me()
      ..name = ""
      ..id = ""
      ..email = ""
      ..cpf = ""
      ..phone = ""
      ..picture = ""
      ..condominiums = []
      ..lastUpdatedAt = DateTime.now();
  }
}
