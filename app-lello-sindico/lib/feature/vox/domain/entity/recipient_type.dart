/// Tipo de destinatário de um documento ("enviar para").
///
/// Substitui os "magic numbers" espalhados em `switch` pela camada inteira
/// (item B4). O [value] é o número que trafega no fio (`recipient_type`) e é
/// contrato com o backend: **3=TODOS (condomínio), 4=BLOCO, 5=UNIDADES**.
///
/// Histórico: versões antigas enviavam `0` para "todos". O backend ainda aceita
/// `0` como entrada legada (deprecated); na leitura, [fromValue] mapeia `0 → all`.
enum RecipientType {
  /// Todos os moradores do condomínio (envia o condomínio inteiro ao VOX).
  all(3),

  /// Blocos específicos.
  block(4),

  /// Unidades específicas.
  units(5);

  final int value;
  const RecipientType(this.value);

  static RecipientType? fromValue(int? value) {
    if (value == null) return null;
    // DEPRECATED: app antigo / backend legado usavam 0 para "todos".
    if (value == 0) return all;
    for (final type in RecipientType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}
