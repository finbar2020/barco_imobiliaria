import 'package:essentials/input_formatter/cpf_and_cnpj_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _valor(String texto) => TextEditingValue(
    text: texto, selection: TextSelection.collapsed(offset: texto.length));

void main() {
  test('começa com a máscara de CPF', () {
    final f = CpfOrCnpjInputFormatter();
    expect(f.current, isNull);
    final r = f.formatEditUpdate(TextEditingValue.empty, _valor('123'));
    expect(r.text, '123');
    expect(f.current, same(f.cpf));
  });

  test('11 dígitos formata como CPF', () {
    final f = CpfOrCnpjInputFormatter();
    final r = f.formatEditUpdate(TextEditingValue.empty, _valor('12345678901'));
    expect(r.text, '123.456.789-01');
    expect(f.current, isNot(same(f.cpf)));
  });

  test('mais de 11 dígitos troca para CNPJ', () {
    final f = CpfOrCnpjInputFormatter();
    f.formatEditUpdate(TextEditingValue.empty, _valor('12345678901'));
    final r = f.formatEditUpdate(_valor('123.456.789-01'), _valor('123456789012'));
    expect(r.text, '12.345.678/9012');
    final completo =
        f.formatEditUpdate(r, _valor('12345678000195'));
    expect(completo.text, '12.345.678/0001-95');
  });

  test('apagando dígitos continua usando a máscara atual', () {
    final f = CpfOrCnpjInputFormatter();
    f.formatEditUpdate(TextEditingValue.empty, _valor('12345678000195'));
    final r = f.formatEditUpdate(_valor('12.345.678/0001-95'), _valor('1234'));
    expect(r.text, '12.34');
  });
}
