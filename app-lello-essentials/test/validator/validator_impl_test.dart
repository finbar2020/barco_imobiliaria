import 'package:essentials/validator/validator_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

void main() {
  late ValidatorImpl validator;

  /// Monta um contexto com o `AppLocalization` de teste (devolve a chave).
  Future<void> prepara(WidgetTester tester) async {
    await pumpApp(tester, const Text('ctx'));
    validator = ValidatorImpl()..context = tester.element(find.text('ctx'));
  }

  testWidgets('validateRequired e validatePassword', (tester) async {
    await prepara(tester);
    expect(validator.validateRequired(null), 'validation_required');
    expect(validator.validateRequired(''), 'validation_required');
    expect(validator.validateRequired('a'), isNull);
    expect(validator.validatePassword(''), 'validation_required');
    expect(validator.validatePassword('123'), isNull);
  });

  testWidgets('validateRequiredWithoutText devolve vazio em vez de mensagem',
      (tester) async {
    await prepara(tester);
    expect(validator.validateRequiredWithoutText(null), '');
    expect(validator.validateRequiredWithoutText(''), '');
    expect(validator.validateRequiredWithoutText('x'), isNull);
  });

  testWidgets('validateExisting', (tester) async {
    await prepara(tester);
    expect(validator.validateExisting(null), 'validation_required');
    expect(validator.validateExisting(''), 'validation_required');
    expect(validator.validateExisting('a'), isNull);
    expect(validator.validateExisting(0), isNull);
  });

  testWidgets('validateEmail', (tester) async {
    await prepara(tester);
    expect(validator.validateEmail(null), 'validation_required');
    expect(validator.validateEmail(''), 'validation_required');
    expect(validator.validateEmail('sem-arroba'), 'validation_invalid_email');
    expect(validator.validateEmail('a@b'), 'validation_invalid_email');
    expect(validator.validateEmail('fulano@lello.com.br'), isNull);
    expect(validator.validateEmail('"nome estranho"@lello.com'), isNull);
    expect(validator.validateEmail('a@[192.168.0.1]'), isNull);
  });

  testWidgets('tamanhos mínimo, máximo e exato usam sprintf', (tester) async {
    await prepara(tester);
    expect(validator.validateMinLength('ab', 3), 'validation_invalid_min_length');
    expect(validator.validateMinLength(null, 3), 'validation_invalid_min_length');
    expect(validator.validateMinLength('abc', 3), isNull);
    expect(validator.validateMaxLength('abcd', 3), 'validation_invalid_max_length');
    expect(validator.validateMaxLength(null, 3), 'validation_invalid_max_length');
    expect(validator.validateMaxLength('abc', 3), isNull);
    expect(validator.validateExactLength('ab', 3), 'validation_invalid_length');
    expect(validator.validateExactLength('abc', 3), isNull);
  });

  testWidgets('mensagens com %s são formatadas quando há tradução',
      (tester) async {
    await pumpApp(tester, const Text('ctx'), locOverrides: {
      'validation_invalid_min_length': 'mínimo %s',
      'validation_invalid_max_length': 'máximo %s',
      'validation_invalid_length': 'exato %s',
    });
    final v = ValidatorImpl()..context = tester.element(find.text('ctx'));
    expect(v.validateMinLength('a', 2), 'mínimo 2');
    expect(v.validateMaxLength('abc', 2), 'máximo 2');
    expect(v.validateExactLength('abc', 2), 'exato 2');
  });

  testWidgets('validateCellPhone', (tester) async {
    await prepara(tester);
    expect(validator.validateCellPhone(null), 'validation_invalid_phone');
    expect(validator.validateCellPhone('123'), 'validation_invalid_phone');
    expect(validator.validateCellPhone('(11) 99999-8888'), isNull);
    expect(validator.validateCellPhone('+55 11 999998888'), isNull);
    expect(validator.validateCellPhone('11999998888'), isNull);
  });

  testWidgets('validateLandlinePhone', (tester) async {
    await prepara(tester);
    expect(validator.validateLandlinePhone(null), 'validation_invalid_landline');
    expect(validator.validateLandlinePhone('11 99999-8888'),
        'validation_invalid_landline');
    expect(validator.validateLandlinePhone('(11) 3333-4444'), isNull);
    expect(validator.validateLandlinePhone('33334444'), isNull);
  });

  testWidgets('validateCPF', (tester) async {
    await prepara(tester);
    expect(validator.validateCPF(null), 'validation_invalid_cpf');
    expect(validator.validateCPF(''), 'validation_required');
    expect(validator.validateCPF('123'), 'validation_invalid_length');
    expect(validator.validateCPF('111.111.111-11'), 'validation_invalid_cpf');
    expect(validator.validateCPF('529.982.247-26'), 'validation_invalid_cpf');
    expect(validator.validateCPF('529.982.247-25'), isNull);
    expect(validator.validateCPF('52998224725'), isNull);
    // Primeiro dígito verificador errado.
    expect(validator.validateCPF('52998224715'), 'validation_invalid_cpf');
  });

  testWidgets('validateCNPJ', (tester) async {
    await prepara(tester);
    expect(validator.validateCNPJ(null), 'validation_required');
    expect(validator.validateCNPJ('123'), 'validation_invalid_length');
    expect(validator.validateCNPJ('11.111.111/1111-11'), 'validation_invalid_cnpj');
    expect(validator.validateCNPJ('11.222.333/0001-81'), isNull);
    expect(validator.validateCNPJ('11222333000181'), isNull);
    expect(validator.validateCNPJ('11222333000191'), 'validation_invalid_cnpj');
    expect(validator.validateCNPJ('11222333000182'), 'validation_invalid_cnpj');
  });

  testWidgets('validateCPForCNPJ decide pelo tamanho', (tester) async {
    await prepara(tester);
    expect(validator.validateCPForCNPJ('', optional: true), isNull);
    expect(validator.validateCPForCNPJ(null, optional: true), isNull);
    expect(validator.validateCPForCNPJ('529.982.247-25'), isNull);
    expect(validator.validateCPForCNPJ('11.222.333/0001-81'), isNull);
    expect(validator.validateCPForCNPJ('123'), 'validation_invalid_length');
  });

  /// Corrigido: `validateCPForCNPJ(null)` (não opcional) trata nulo como
  /// vazio e devolve "campo obrigatório" em vez de lançar.
  testWidgets('validateCPForCNPJ com nulo devolve campo obrigatório',
      (tester) async {
    await prepara(tester);
    expect(validator.validateCPForCNPJ(null), 'validation_required');
    expect(validator.validateCPForCNPJ(''), 'validation_required');
  });

  testWidgets('validateDate usa o formato yMd do locale padrão', (tester) async {
    await prepara(tester);
    expect(validator.validateDate('', optional: true), isNull);
    expect(validator.validateDate(''), 'validation_invalid_date');
    expect(validator.validateDate(null), 'validation_invalid_date');
    expect(validator.validateDate('31/31/2020'), 'validation_invalid_date');
    expect(validator.validateDate('12/25/2020'), isNull);
  });

  testWidgets('validateDateBeforeToday', (tester) async {
    await prepara(tester);
    expect(validator.validateDateBeforeToday('', optional: true), isNull);
    expect(validator.validateDateBeforeToday('abc'), 'validation_invalid_date');
    expect(validator.validateDateBeforeToday('1/1/2000'), isNull);
    expect(validator.validateDateBeforeToday('1/1/2999'), 'validation_invalid_date');
  });

  testWidgets('validateTime usa o formato jm', (tester) async {
    await prepara(tester);
    // O CLDR do intl 0.20 separa hora e AM/PM com U+202F (narrow no-break
    // space); o espaço comum não é aceito pelo parseStrict.
    expect(validator.validateTime('10:30\u202fAM'), isNull);
    expect(validator.validateTime('10:30 AM'), 'validation_invalid_time');
    expect(validator.validateTime('25:99'), 'validation_invalid_time');
  });

  testWidgets('validateHourMinute', (tester) async {
    await prepara(tester);
    expect(validator.validateHourMinute('xx', false), isNull);
    expect(validator.validateHourMinute('1:30', true), 'Horário inválido');
    expect(validator.validateHourMinute('10:30', true), isNull);
    expect(validator.validateHourMinute('99:99', true), 'validation_invalid_time');
  });

  testWidgets('validatePositiveValue', (tester) async {
    await prepara(tester);
    expect(validator.validatePositiveValue('R\$1,234.56'), isNull);
    expect(validator.validatePositiveValue('0.00'), 'validation_invalid_value');
    expect(validator.validatePositiveValue('abc'), 'validation_invalid_value');
    expect(validator.validatePositiveValue('R\$0.50'), isNull);
  });

  testWidgets('validatePositiveValue aceita inteiros e valores negativos falham',
      (tester) async {
    await prepara(tester);
    expect(validator.validatePositiveValue('R\$10'), isNull);
    expect(validator.validatePositiveValue('-5.00'), 'validation_invalid_value');
  });

  testWidgets('validatePassport', (tester) async {
    await prepara(tester);
    expect(validator.validatePassport(null), 'validation_required');
    expect(validator.validatePassport('AB12'), 'validation_invalid_min_length');
    expect(validator.validatePassport('AB123456789'), 'validation_invalid_max_length');
    expect(validator.validatePassport('AB12345'), isNull);
  });

  testWidgets('validateRNE exige 8 caracteres sem pontuação', (tester) async {
    await prepara(tester);
    expect(validator.validateRNE('AB12345-X'), isNull);
    expect(validator.validateRNE('AB1'), 'validation_invalid_length');
  });

  /// Corrigido: `validateRNE(null)` trata nulo como vazio e devolve a mesma
  /// mensagem de tamanho inválido em vez de lançar.
  testWidgets('validateRNE com nulo devolve tamanho inválido', (tester) async {
    await prepara(tester);
    expect(validator.validateRNE(null), 'validation_invalid_length');
    expect(validator.validateRNE(''), 'validation_invalid_length');
  });
}
