import 'package:essentials/input_formatter/currency_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _valor(String texto) => TextEditingValue(
    text: texto, selection: TextSelection.collapsed(offset: texto.length));

void main() {
  test('formata centavos com símbolo e cursor no fim', () {
    final r = CurrencyInputFormatter()
        .formatEditUpdate(TextEditingValue.empty, _valor('123456'));
    expect(r.text, 'R\$1,234.56');
    expect(r.selection.baseOffset, r.text.length);
  });

  test('sem símbolo', () {
    final r = CurrencyInputFormatter(showSymbol: false)
        .formatEditUpdate(TextEditingValue.empty, _valor('R\$ 1,0'));
    expect(r.text, '0.10');
  });

  test('corta em 16 dígitos', () {
    final r = CurrencyInputFormatter(showSymbol: false)
        .formatEditUpdate(TextEditingValue.empty, _valor('1' * 20));
    expect(r.text, '11,111,111,111,111.11');
  });

  /// Corrigido: ao apagar todo o conteúdo o valor é formatado como 0.00 em
  /// vez de lançar FormatException.
  test('texto vazio formata zero', () {
    final r = CurrencyInputFormatter()
        .formatEditUpdate(TextEditingValue.empty, TextEditingValue.empty);
    expect(r.text, 'R\$0.00');
    expect(r.selection.baseOffset, r.text.length);
    expect(
        CurrencyInputFormatter(showSymbol: false)
            .formatEditUpdate(TextEditingValue.empty, _valor('abc'))
            .text,
        '0.00');
  });
}
