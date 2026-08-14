import 'package:morar/feature/home/domain/entity/unity.dart';

class Block {
  String? id;
  String? name;
  List<Unity>? units;

  Block({this.id, this.name, this.units});

  int get unitsLength => units?.length ?? 0;
}
