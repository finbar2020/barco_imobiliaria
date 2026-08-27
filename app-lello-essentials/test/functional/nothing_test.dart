import 'package:essentials/functional/nothing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Nothing pode ser instanciado', () {
    expect(Nothing(), isA<Nothing>());
  });
}
