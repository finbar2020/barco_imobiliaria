// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';

class BlockSimple {
  final String id;
  final String name;
  final List<UnitSimple> units;
  BlockSimple({
    required this.id,
    required this.name,
    required this.units,
  });
}
