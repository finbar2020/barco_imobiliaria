import 'package:essentials/input_formatter/cpf_and_cnpj_input_formatter.dart';
import 'package:essentials/input_formatter/currency_input_formatter.dart';
import 'package:essentials/input_formatter/input_formatter_preset.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

String _aplica(TextInputFormatter f, String texto) => f
    .formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(
          text: texto, selection: TextSelection.collapsed(offset: texto.length)),
    )
    .text;

void main() {
  test('cpfFormatter', () {
    expect(_aplica(cpfFormatter(), '12345678901'), '123.456.789-01');
    expect(_aplica(cpfFormatter(), '123a45'), '123.45');
  });

  test('cnpjFormatter', () {
    expect(_aplica(cnpjFormatter(), '12345678000195'), '12.345.678/0001-95');
  });

  test('telefones fixos', () {
    expect(_aplica(landlinePhoneFormatter(), '33334444'), '3333-4444');
    expect(_aplica(landlinePhoneWithDDDFormatter(), '1133334444'),
        '(11) 3333-4444');
  });

  test('celulares', () {
    expect(_aplica(cellphoneFormatter(), '999998888'), '99999-8888');
    expect(_aplica(cellphoneWithDDDFormatter(), '11999998888'),
        '(11) 99999-8888');
  });

  test('datas e horário', () {
    expect(_aplica(dateFormatter(), '122024'), '12/2024');
    expect(_aplica(fullDateFormatter(), '31122024'), '31/12/2024');
    expect(_aplica(timeFormatter(), '1230'), '12:30');
  });

  test('documentos', () {
    expect(_aplica(rgFormatter(), '123456789'), '12.345.678-9');
    expect(_aplica(rneFormatter(), 'AB12345X'), 'AB12345-X');
    expect(_aplica(passportFormatter(), 'AB1234567890'), 'AB12345678');
    expect(_aplica(cepFormatter(), '01001000'), '01001-000');
  });

  test('currencyFormatter e cpfOrCnpjFormatter devolvem os formatadores próprios',
      () {
    expect(currencyFormatter(), isA<CurrencyInputFormatter>());
    expect((currencyFormatter(showSymbol: false) as CurrencyInputFormatter).showSymbol,
        isFalse);
    expect(cpfOrCnpjFormatter(), isA<CpfOrCnpjInputFormatter>());
  });
}
