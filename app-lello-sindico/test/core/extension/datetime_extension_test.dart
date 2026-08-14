import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';

void main() {
  final DateTime _december2020 = DateTime(2020, 12, 12);
  final DateTime _december2020Start = DateTime(2020, 12, 1);
  final DateTime _december2020End = DateTime(2020, 12, 31);

  final DateTime _may2019Time = DateTime(2019, 5, 12, 12, 5, 22);
  final DateTime _may2019TimeStart = DateTime(2019, 5, 1);
  final DateTime _may2019TimeEnd = DateTime(2019, 5, 31);

  group('Get first day', () {
    test('Should return correct date', () async {
      expect(_december2020.firstDayOfMonth(), equals(_december2020Start));
    });

    test('Should return correct date without minutes', () async {
      expect(_may2019Time.firstDayOfMonth(), equals(_may2019TimeStart));
    });
  });

  group('Get last day', () {
    test('Should return correct date', () async {
      expect(_december2020.lastDayOfMonth(), equals(_december2020End));
    });

    test('Should return correct date without minutes', () async {
      expect(_may2019Time.lastDayOfMonth(), equals(_may2019TimeEnd));
    });
  });
}
