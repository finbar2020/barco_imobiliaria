import 'package:morar/feature/me/domain/entity/block.dart';
import 'package:morar/feature/me/domain/entity/layout.dart';

class Condominium {
  String? id;
  String? reference;
  String? name;
  String? address;
  // Address address;
  List<Block>? blocks;
  String? regulationUrl;
  bool? active_manager;
  bool useFacialBiometric;
  Layout? layout;
  Condominium({
    this.id,
    this.reference,
    this.name,
    this.address,
    this.regulationUrl,
    this.blocks,
    this.active_manager,
    this.useFacialBiometric = true,
    this.layout,
  });

  factory Condominium.clone(Condominium condominium) => Condominium()
    ..id = condominium.id
    ..regulationUrl = condominium.regulationUrl
    ..reference = condominium.reference
    ..name = condominium.name
    ..address = condominium.address
    ..blocks = condominium.blocks
    ..active_manager = condominium.active_manager
    ..useFacialBiometric = condominium.useFacialBiometric
    ..layout = condominium.layout;

  int get unitsLength {
    if (blocks == null) return 0;
    var units = 0;
    blocks!.forEach((element) {
      units += element.unitsLength;
    });
    return units;
  }

  @override
  String toString() {
    return 'Condominium(id: $id, reference: $reference, name: $name, address: $address, blocks: $blocks, regulationUrl: $regulationUrl, useFacialBiometric: $useFacialBiometric)';
  }
}
