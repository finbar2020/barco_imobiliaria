import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Validator validator = ValidatorImpl();

  setUp(() {
    validator = ValidatorImpl();
  });

  group('Validate email', () {
    group('With invalid email', () {
      test('Should return expected error when text is null', () async {
        expect(validator.validateEmail(null), isNotEmpty);
      });
      test('Should return expected error when text is empty', () async {
        expect(validator.validateEmail(""), isNotEmpty);
      });
      test('Should return expected error when text does not contain @',
          () async {
        expect(validator.validateEmail("testenoknox.com.br"), isNotEmpty);
      });
      test('Should return expected error when text does not contain .',
          () async {
        expect(validator.validateEmail("test@enoknoxcombr"), isNotEmpty);
      });
      test('Should return expected error when email is invalid', () async {
        expect(validator.validateEmail("test@.noknox.com.br"), isNotEmpty);
        expect(validator.validateEmail("test@noknox..com.br"), isNotEmpty);
        expect(validator.validateEmail("test@noknox"), isNotEmpty);
      });
    });
    group('With valid email', () {
      test('Should return null when text is a valid email', () async {
        expect(validator.validateEmail("test@noknox.com.br"), isNull);
      });
    });
  });
  group('Validate minLength', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateMinLength(null, 1), isNotEmpty);
      });

      test('Should return error when text is smaller than expected', () async {
        expect(validator.validateMinLength("12", 5), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text length is equal to expected',
          () async {
        expect(validator.validateMinLength("12", 2), isNull);
      });
      test('Should return null when text is bigger than expected', () async {
        expect(validator.validateMinLength("123", 2), isNull);
      });
    });
  });
  group('Validate maxLength', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateMaxLength(null, 1), isNotEmpty);
      });

      test('Should return error when text is bigger than expected', () async {
        expect(validator.validateMaxLength("123", 2), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text length is equal to expected',
          () async {
        expect(validator.validateMaxLength("12", 2), isNull);
      });
      test('Should return null when text is smaller than expected', () async {
        expect(validator.validateMaxLength("12", 3), isNull);
      });
    });
  });
  group('Validate exactLength', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateExactLength(null, 1), isNotEmpty);
      });

      test('Should return error when text is bigger than expected', () async {
        expect(validator.validateExactLength("123", 2), isNotEmpty);
      });

      test('Should return error when text is smaller than expected', () async {
        expect(validator.validateExactLength("1", 2), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text length is equal to expected',
          () async {
        expect(validator.validateMaxLength("12", 2), isNull);
      });
    });
  });
  group('Validate required', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateRequired(null), isNotEmpty);
      });

      test('Should return error when text is empty', () async {
        expect(validator.validateRequired(""), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text is not null nor empty', () async {
        expect(validator.validateRequired("1"), isNull);
      });
    });
  });
  group('Validate password', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validatePassword(null), isNotEmpty);
      });

      test('Should return error when text is empty', () async {
        expect(validator.validatePassword(""), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text is not null nor empty', () async {
        expect(validator.validatePassword("1"), isNull);
      });
    });
  });
  group('Validate phone', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validatePhone(null), isNotEmpty);
      });

      test('Should return error when text is empty', () async {
        expect(validator.validatePhone(""), isNotEmpty);
      });

      test('Should return error when text contains caracter', () async {
        expect(validator.validatePhone("61999999999a"), isNotEmpty);
      });

      test('Should return error when text smaller than expected', () async {
        expect(validator.validatePhone("61999"), isNotEmpty);
      });
      test('Should return error when text bigger than expected', () async {
        expect(validator.validatePhone("6199999999990"), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text is a valida phone', () async {
        expect(validator.validatePhone("+5561999999999"), isNull);
        expect(validator.validatePhone("+556199999999"), isNull);
        expect(validator.validatePhone("+55 (61) 99999-9999"), isNull);
        expect(validator.validatePhone("+55(61)99999-9999"), isNull);
        expect(validator.validatePhone("+55(61)9999-9999"), isNull);
        expect(validator.validatePhone("+55 61 99999999"), isNull);
        expect(validator.validatePhone("(61) 99999-9999"), isNull);
        expect(validator.validatePhone("(61) 9999-9999"), isNull);
        expect(validator.validatePhone("61 99999-9999"), isNull);
        expect(validator.validatePhone("61 9999-9999"), isNull);
        expect(validator.validatePhone("99999-9999"), isNull);
        expect(validator.validatePhone("9999-9999"), isNull);
        expect(validator.validatePhone("999999999"), isNull);
        expect(validator.validatePhone("99999999"), isNull);
      });
    });
  });
  group('Validate cpf', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateCPF(null), isNotEmpty);
      });

      test('Should return error when text is empty', () async {
        expect(validator.validateCPF(""), isNotEmpty);
      });

      test('Should return error when text contains letters', () async {
        expect(validator.validateCPF("154.045.165-a5"), isNotEmpty);
      });

      test('Should return error when text smaller than expected', () async {
        expect(validator.validateCPF("154"), isNotEmpty);
      });
      test('Should return error when text bigger than expected', () async {
        expect(validator.validateCPF("154.045.165-854"), isNotEmpty);
        expect(validator.validateCPF("154045165854"), isNotEmpty);
      });
      test('Should return error when text contains only one number', () async {
        expect(validator.validateCPF("000.000.000-00"), isNotEmpty);
        expect(validator.validateCPF("11111111111"), isNotEmpty);
      });
      test('Should return error when text contains invalid verificationndigits',
          () async {
        expect(validator.validateCPF("154.045.165-75"), isNotEmpty);
        expect(validator.validateCPF("154.045.165-84"), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text is a valid cpf', () async {
        expect(validator.validateCPF("154.045.165-85"), isNull);
        expect(validator.validateCPF("15404516585"), isNull);
      });
    });
  });
  group('Validate cnpj', () {
    group('With invalid data', () {
      test('Should return error when text is null', () async {
        expect(validator.validateCNPJ(null), isNotEmpty);
      });

      test('Should return error when text is empty', () async {
        expect(validator.validateCNPJ(""), isNotEmpty);
      });

      test('Should return error when text contains letters', () async {
        expect(validator.validateCNPJ("98.892.156/0001-a9"), isNotEmpty);
      });

      test('Should return error when text smaller than expected', () async {
        expect(validator.validateCNPJ("98.892.156/0001-2"), isNotEmpty);
      });
      test('Should return error when text bigger than expected', () async {
        expect(validator.validateCNPJ("98.892.156/0001-292"), isNotEmpty);
        expect(validator.validateCNPJ("988921560001292"), isNotEmpty);
      });
      test('Should return error when text contains only one number', () async {
        expect(validator.validateCPF("00.000.000/0000-00"), isNotEmpty);
        expect(validator.validateCPF("11111111111111"), isNotEmpty);
      });
      test('Should return error when text contains invalid verification digits',
          () async {
        expect(validator.validateCNPJ("98.892.156/0001-21"), isNotEmpty);
        expect(validator.validateCNPJ("98.892.156/0001-39"), isNotEmpty);
      });
    });

    group('With valid data', () {
      test('Should return null when text is a valid cnpj', () async {
        expect(validator.validateCNPJ("98.892.156/0001-29"), isNull);
        expect(validator.validateCNPJ("98892156000129"), isNull);
      });
    });
  });

  group('Validate Date', () {
    group('With invalid date', () {
      test('Should return expected error when text is null', () async {
        expect(validator.validateDate(null), isNotEmpty);
      });
      test('Should return expected error when text is empty', () async {
        expect(validator.validateDate(""), isNotEmpty);
      });
      test('Should return expected error when text does not contain /',
          () async {
        expect(validator.validateDate("20032020"), isNotEmpty);
      });
      test('Should return expected error when text has invalid months',
          () async {
        expect(validator.validateDate("30/03/2020"), isNotEmpty);
      });
      test('Should return expected error when text has invalid days', () async {
        expect(validator.validateDate("12/36/2020"), isNotEmpty);
      });
      test('Should return expected error when year is missing', () async {
        expect(validator.validateDate("30/12"), isNotEmpty);
      });
    });
    group('With valid date', () {
      test('Should return null when text is a valid date', () async {
        expect(validator.validateDate("12/30/2020"), isNull);
      });
    });

    group('Validate Optional Date', () {
      group('With invalid date', () {
        test('Should return expected error when text does not contain /',
            () async {
          expect(
              validator.validateDate("20032020", optional: true), isNotEmpty);
        });
        test('Should return expected error when text has invalid months',
            () async {
          expect(
              validator.validateDate("30/03/2020", optional: true), isNotEmpty);
        });
        test('Should return expected error when text has invalid days',
            () async {
          expect(
              validator.validateDate("12/36/2020", optional: true), isNotEmpty);
        });
        test('Should return expected error when year is missing', () async {
          expect(validator.validateDate("30/12", optional: true), isNotEmpty);
        });
      });
      group('With valid date', () {
        test('Should return null when text is a valid date', () async {
          expect(validator.validateDate("12/30/2020", optional: true), isNull);
        });

        test('Should return null when text is null', () async {
          expect(validator.validateDate(null, optional: true), isNull);
        });
        test('Should return null when text is empty', () async {
          expect(validator.validateDate("", optional: true), isNull);
        });
      });
    });
  });
}
