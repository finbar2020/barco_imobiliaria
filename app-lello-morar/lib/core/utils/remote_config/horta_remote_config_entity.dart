import 'package:essentials/essentials.dart';

class HortaRemoteConfigEntity {
  String? dataAte;
  String? link;
  String? cupom;

  HortaRemoteConfigEntity({
    this.dataAte,
    this.link,
    this.cupom,
  });

  static HortaRemoteConfigEntity fromRemote(dynamic json) =>
      HortaRemoteConfigEntity(
        dataAte: json["dataAte"],
        link: json["link"],
        cupom: json["cupom"],
      );

  DateTime? get limitDate => dataAte?.isNotEmpty == true
      ? DateFormat.yMd("pt-Br").parse("$dataAte! 23:59:59")
      : null;
}
