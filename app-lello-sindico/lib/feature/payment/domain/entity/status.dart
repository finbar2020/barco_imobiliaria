class StatusEntity {
  final int? idStatus;
  final String? descricaoStatus;
  final dynamic flagStatus;
  final List<dynamic> listStatusTipoStatusVO;

  StatusEntity({
    this.idStatus,
    this.descricaoStatus,
    this.flagStatus,
    this.listStatusTipoStatusVO = const [],
  });

  StatusEntity copyWith({
    int? idStatus,
    String? descricaoStatus,
    dynamic flagStatus,
    List<dynamic>? listStatusTipoStatusVO,
  }) {
    return StatusEntity(
      idStatus: idStatus ?? this.idStatus,
      descricaoStatus: descricaoStatus ?? this.descricaoStatus,
      flagStatus: flagStatus ?? this.flagStatus,
      listStatusTipoStatusVO:
          listStatusTipoStatusVO ?? this.listStatusTipoStatusVO,
    );
  }
}
