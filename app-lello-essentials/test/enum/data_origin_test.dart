import 'package:essentials/enum/code_validation_origin.dart';
import 'package:essentials/enum/code_validation_source.dart';
import 'package:essentials/enum/data_origin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DataOrigin tem local e remote', () {
    expect(DataOrigin.values, [DataOrigin.local, DataOrigin.remote]);
  });

  test('enums de validação de código', () {
    expect(CodeValidationOrigin.values.length, 4);
    expect(CodeValidationSource.values,
        [CodeValidationSource.email, CodeValidationSource.phone, CodeValidationSource.biometria]);
  });
}
