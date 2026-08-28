import 'package:essentials/extension/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formata CPF com 11 dígitos', () {
    expect('12345678901'.formatCpfCnpj(), '123.456.789-01');
    expect('123.456.789-01'.formatCpfCnpj(), '123.456.789-01');
  });

  test('formata CNPJ com 14 dígitos', () {
    expect('12345678000195'.formatCpfCnpj(), '12.345.678/0001-95');
    expect('12.345.678/0001-95'.formatCpfCnpj(), '12.345.678/0001-95');
  });

  test('tamanho diferente devolve só os dígitos', () {
    expect('12.3'.formatCpfCnpj(), '123');
    expect(''.formatCpfCnpj(), '');
  });
}
