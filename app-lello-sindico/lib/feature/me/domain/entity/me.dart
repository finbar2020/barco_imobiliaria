// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:lello/feature/condominium/domain/entity/condominium.dart';

class Me {
  final String? name;
  final String? id;
  final String? email;
  final String? cpf;
  final String? phone;
  final String? picture;
  final String? pictureHash;
  final List<Condominium>? condominiums;
  final File? pictureFile;

  factory Me.clone(Me me) {
    return Me(
      name: me.name,
      id: me.id,
      email: me.email,
      cpf: me.cpf,
      phone: me.phone,
      picture: me.picture,
      condominiums: me.condominiums?.map((e) => Condominium.clone(e)).toList(),
      pictureHash: me.pictureHash,
      pictureFile: me.pictureFile,
    );
  }

  Me({
    this.name,
    this.id,
    this.email,
    this.cpf,
    this.phone,
    this.picture,
    this.pictureHash,
    this.condominiums,
    this.pictureFile,
  });

  compareStr(Me originalMe) {
    List<String> changes = [];
    if (name != originalMe.name) changes.add("nome");
    if (email != originalMe.email) changes.add("email");
    if (cpf != originalMe.cpf) changes.add("cpf");
    if (phone != originalMe.phone) changes.add("telefone");
    if (picture != originalMe.picture) changes.add("imagem");
    return changes.join(', ');
  }

  Me copyWith({
    String? name,
    String? id,
    String? email,
    String? cpf,
    String? phone,
    String? picture,
    String? pictureHash,
    String? pictureLink,
    List<Condominium>? condominiums,
    File? pictureFile,
  }) {
    return Me(
      name: name ?? this.name,
      id: id ?? this.id,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      picture: picture ?? this.picture,
      pictureHash: pictureHash ?? this.pictureHash,
      condominiums: condominiums ?? this.condominiums,
      pictureFile: pictureFile ?? this.pictureFile,
    );
  }

  int get allCondominiums {
    return condominiums?.length ?? 0;
  }

  List<Condominium> get allCondominiunsEntity {
    List<Condominium> condos = [];
    condominiums!.map((Condominium e) {
      condos.add(e);
    }).toList();
    return condos;
  }

  String get pictureLink =>
      pictureHash?.isNotEmpty == true ? "/me/pictures/file/$pictureHash" : "";
}
