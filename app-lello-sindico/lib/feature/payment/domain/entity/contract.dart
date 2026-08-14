class ContractEntity {
  final int? id;
  final String? code;

  ContractEntity({
    this.id,
    this.code,
  });

  ContractEntity copyWith({
    int? id,
    String? code,
  }) {
    return ContractEntity(
      id: id ?? this.id,
      code: code ?? this.code,
    );
  }
}
