class LedgerAccountEntity {
  final int? id;
  final int? shortCode;
  final String? name;

  LedgerAccountEntity({
    this.id,
    this.shortCode,
    this.name,
  });

  LedgerAccountEntity copyWith({
    int? id,
    int? shortCode,
    String? name,
  }) {
    return LedgerAccountEntity(
      id: id ?? this.id,
      shortCode: shortCode ?? this.shortCode,
      name: name ?? this.name,
    );
  }
}
