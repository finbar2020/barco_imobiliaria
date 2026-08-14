class TipoFornecedorEntity {
  final int? idTipoFornecedor;
  final String? nomeTipoFornecedor;
  final String? codigoTipoFornecedor;

  TipoFornecedorEntity({
    this.idTipoFornecedor,
    this.nomeTipoFornecedor,
    this.codigoTipoFornecedor,
  });

  TipoFornecedorEntity copyWith({
    int? idTipoFornecedor,
    String? nomeTipoFornecedor,
    String? codigoTipoFornecedor,
  }) {
    return TipoFornecedorEntity(
      idTipoFornecedor: idTipoFornecedor ?? this.idTipoFornecedor,
      nomeTipoFornecedor: nomeTipoFornecedor ?? this.nomeTipoFornecedor,
      codigoTipoFornecedor: codigoTipoFornecedor ?? this.codigoTipoFornecedor,
    );
  }
}
