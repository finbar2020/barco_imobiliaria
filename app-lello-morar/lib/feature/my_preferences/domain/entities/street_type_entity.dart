class StreetTypeEntity {
  final String type;
  final String name;
  final String dtFlex;

  StreetTypeEntity({
    required this.type,
    required this.name,
    required this.dtFlex,
  });

  StreetTypeEntity copyWith({
    String? type,
    String? name,
    String? dtFlex,
  }) {
    return StreetTypeEntity(
      type: type ?? this.type,
      name: name ?? this.name,
      dtFlex: dtFlex ?? this.dtFlex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tpLogradouro': type,
      'nmTpLogradouro': name,
      'dtFlex': dtFlex,
    };
  }

  factory StreetTypeEntity.fromMap(Map<String, dynamic> map) {
    return StreetTypeEntity(
      type: map['tpLogradouro'],
      name: map['nmTpLogradouro'],
      dtFlex: map['dtFlex'],
    );
  }
}