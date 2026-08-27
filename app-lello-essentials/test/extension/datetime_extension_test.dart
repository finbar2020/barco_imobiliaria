import 'package:essentials/extension/datetime_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeUtils.fromFormattedString', () {
    test('nulo devolve nulo', () {
      expect(DateTimeUtils.fromFormattedString(null), isNull);
    });

    test('converte dd/MM/yyyy completando dígitos', () {
      expect(DateTimeUtils.fromFormattedString('5/3/2024'), DateTime(2024, 3, 5));
      expect(DateTimeUtils.fromFormattedString('15/12/2023'),
          DateTime(2023, 12, 15));
    });

    /// Corrigido: formato inesperado (sem 3 partes ou não numérico) devolve
    /// nulo em vez de lançar.
    test('formato inválido devolve nulo', () {
      expect(DateTimeUtils.fromFormattedString('2024'), isNull);
      expect(DateTimeUtils.fromFormattedString('1/2/3/4'), isNull);
      expect(DateTimeUtils.fromFormattedString('aa/bb/cccc'), isNull);
    });
  });

  group('DateTimeUtils.tryParseDate', () {
    test('vazio devolve nulo', () {
      expect(DateTimeUtils.tryParseDate('', 'dd/MM/yyyy'), isNull);
    });

    test('padrão válido converte', () {
      expect(DateTimeUtils.tryParseDate('01/02/2024', 'dd/MM/yyyy'),
          DateTime(2024, 2, 1));
    });

    test('entrada inválida devolve nulo', () {
      expect(DateTimeUtils.tryParseDate('abc', 'dd/MM/yyyy'), isNull);
    });
  });

  group('DateTimeExtensions', () {
    final data = DateTime(2024, 2, 5, 13, 7, 9);

    test('toFormattedString sem zero à esquerda', () {
      expect(data.toFormattedString(), '5/2/2024');
    });

    test('toDateTimeFormattedString com hora', () {
      expect(data.toDateTimeFormattedString(), '05/02/2024 13:07:09');
    });

    test('toFormattedFileString usa hífens', () {
      expect(data.toFormattedFileString(), '5-2-2024');
    });

    test('toDayMonthString', () {
      expect(data.toDayMonthString(), '05/02');
    });

    test('firstDayOfMonth e lastDayOfMonth', () {
      expect(data.firstDayOfMonth(), DateTime(2024, 2, 1));
      expect(data.lastDayOfMonth(), DateTime(2024, 2, 29));
      expect(DateTime(2024, 12, 10).lastDayOfMonth(), DateTime(2024, 12, 31));
    });
  });
}
