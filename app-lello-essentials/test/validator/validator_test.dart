import 'package:essentials/validator/validator.dart';
import 'package:essentials/validator/validator_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ValidatorImpl implementa o contrato Validator', () {
    expect(ValidatorImpl(), isA<Validator>());
  });
}
