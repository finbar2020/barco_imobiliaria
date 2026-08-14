import 'dart:io';

import 'package:colaborador/feature/me/domain/entity/condominium.dart';

class Me {
  String id;
  String name;
  String email;
  String cpf;
  String phone;
  String? picture;
  String? pictureHash;
  String? pictureLink;
  List<Condominium> condominiums;
  bool? isTabletSession;

  File? pictureFile;
  DateTime? lastUpdatedAt;

  Me({
    this.id = "",
    this.name = "",
    this.email = "",
    this.cpf = "",
    this.phone = "",
    this.picture,
    this.pictureHash,
    this.pictureLink,
    this.condominiums = const [],
    this.pictureFile,
    this.lastUpdatedAt,
    this.isTabletSession = false,
  });

  factory Me.clone(Me me) => Me(
        id: me.id,
        name: me.name,
        email: me.email,
        cpf: me.cpf,
        phone: me.phone,
        picture: me.picture,
        pictureHash: me.pictureHash,
        pictureLink: me.pictureLink,
        condominiums: me.condominiums,
        pictureFile: me.pictureFile,
        lastUpdatedAt: me.lastUpdatedAt,
        isTabletSession: me.isTabletSession,
      );

  compareStr(Me originalMe) {
    List<String> changes = [];
    if (name != originalMe.name) changes.add("nome");
    if (email != originalMe.email) changes.add("email");
    if (cpf != originalMe.cpf) changes.add("cpf");
    if (phone != originalMe.phone) changes.add("telefone");
    if (picture != originalMe.picture) changes.add("imagem");
    return changes.join(', ');
  }

  void setPictureLink() {
    if (pictureHash != null && pictureHash != "") {
      pictureLink = "/me/pictures/file/$pictureHash";
    }
  }

  String get firstNameFormatted {
    String firstName = name.split(" ").first;
    if (firstName.length > 1) {
      return "${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}";
    }
    return firstName;
  }

  String get nameFormatted {
    List<String> names = name.split(" ");
    List<String> namesFormatted = [];
    for (var element in names) {
      if (element.length > 1) {
        namesFormatted.add(
            "${element[0].toUpperCase()}${element.substring(1).toLowerCase()}");
      }
    }
    return namesFormatted.join(" ");
  }

  bool get hasToUpdate {
    if (lastUpdatedAt != null) {
      return DateTime.now().difference(lastUpdatedAt!).inMinutes > 1;
    } else {
      return false;
    }
  }

  bool get isValid {
    if (condominiums.isEmpty) {
      return false;
    }
    return true;
  }
}
