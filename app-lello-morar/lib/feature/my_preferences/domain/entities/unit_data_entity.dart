import 'package:essentials/essentials.dart';

class UnitDataEntity {
  final int unitId;
  final int reference;
  final String unitName;

  UnitDataEntity({
    required this.unitId,
    required this.reference,
    required this.unitName,
  });

  UnitDataEntity copyWith({
    int? unitId,
    int? reference,
    String? unitName,
  }) =>
      UnitDataEntity(
        unitId: unitId ?? this.unitId,
        reference: reference ?? this.reference,
        unitName: unitName ?? this.unitName,
      );

  factory UnitDataEntity.fromJson(Map<String, dynamic> json) {
    return UnitDataEntity(
      unitId: json['idUnidade'],
      reference: json['referencia'],
      unitName: json['nmUnidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUnidade': unitId,
      'referencia': reference,
      'nmUnidade': unitName,
    };
  }
}
