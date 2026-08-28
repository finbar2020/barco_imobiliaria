import 'package:essentials/input_formatter/lgpd_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatEmail', () {
    test('nulo devolve vazio', () {
      expect(LgpdFormatter.formatEmail(null), '');
    });

    /// Corrigido: a expressão usa `+` em vez de `*`, então não casa mais a
    /// string vazia antes dos dois últimos caracteres — tudo entre os 3
    /// primeiros e os 2 últimos caracteres do usuário vira uma única estrela.
    test('mascara o meio do usuário com uma única estrela', () {
      expect(LgpdFormatter.formatEmail('fulano.silva@lello.com.br'),
          'ful*va@lello.com.br');
      expect(LgpdFormatter.formatEmail('abcdef@x.com'), 'abc*ef@x.com');
      expect(LgpdFormatter.formatEmail('joao_maria+xy@x.com'), 'joa*xy@x.com');
    });

    test('usuário curto (sem nada entre os 3 primeiros e 2 últimos) não é alterado',
        () {
      expect(LgpdFormatter.formatEmail('abc@x.com'), 'abc@x.com');
      expect(LgpdFormatter.formatEmail('abcde@x.com'), 'abcde@x.com');
    });
  });

  group('formatPhone', () {
    test('nulo devolve vazio', () {
      expect(LgpdFormatter.formatPhone(null), '');
    });

    test('curto devolve como está', () {
      expect(LgpdFormatter.formatPhone('1234567'), '1234567');
    });

    test('mascara o meio', () {
      expect(LgpdFormatter.formatPhone('(11) 99999-8888'), '11****8888');
    });
  });

  group('formatCpf', () {
    test('nulo devolve vazio', () {
      expect(LgpdFormatter.formatCpf(null), '');
    });

    test('curto devolve como está', () {
      expect(LgpdFormatter.formatCpf('123.456'), '123.456');
    });

    test('mascara o meio', () {
      expect(LgpdFormatter.formatCpf('123.456.789-01'), '123.***.***-01');
    });
  });
}
