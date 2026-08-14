import 'block_simple.dart';

class CondominiumSimple {
  String id;
  String name;
  String reference;
  List<BlockSimple> blocks;

  CondominiumSimple({
    required this.id,
    required this.name,
    required this.reference,
    required this.blocks,
  });

  CondominiumSimple copyWith({
    String? id,
    String? name,
    String? reference,
    List<BlockSimple>? blocks,
  }) {
    return CondominiumSimple(
      id: id ?? this.id,
      name: name ?? this.name,
      reference: reference ?? this.reference,
      blocks: blocks ?? this.blocks,
    );
  }
}
