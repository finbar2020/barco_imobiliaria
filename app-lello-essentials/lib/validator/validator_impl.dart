import 'package:essentials/validator/validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

import '../app_localization.dart';

class ValidatorImpl implements Validator {
  late BuildContext _context;
  set context(value) {
    _context = value;
  }

  ValidatorImpl();

  @override
  String? validateEmail(String? text) {
    var validate = validateRequired(text);
    if (validate != null) {
      return validate;
    }

    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (text == null || !regex.hasMatch(text))
      return getString(_context, "validation_invalid_email",
          defaultText: "Invalid e-mail");
    else
      return null;
  }

  @override
  String? validateMinLength(String? text, int minLength) {
    if (text != null && text.length >= minLength) {
      return null;
    }

    if (kIsWeb) {
      return "Esse campo precisa ter pelo menos $minLength dígitos";
    }

    var format = getString(_context, "validation_invalid_min_length",
        defaultText: "This field may contain at least %s digits");
    return sprintf(format, [minLength]);
  }

  @override
  String? validateExactLength(String? text, int length) {
    if (text != null && text.length == length) {
      return null;
    }

    if (kIsWeb) {
      return "Esse campo requer $length caracteres";
    }
    var format = getString(_context, "validation_invalid_length",
        defaultText: "This field may only contain %s digits");
    return sprintf(format, [length]);
  }

  @override
  String? validateMaxLength(String? text, int maxLength) {
    if (text != null && text.length <= maxLength) {
      return null;
    }

    if (kIsWeb) {
      return "Esse campo pode ter até $maxLength dígitos";
    }

    var format = getString(_context, "validation_invalid_max_length",
        defaultText: "This field may only at most %s digits");
    return sprintf(format, [maxLength]);
  }

  @override
  String? validatePassword(String? text) {
    return validateRequired(text);
  }

  @override
  String? validateCellPhone(String? text) {
    String pattern =
        r'^(?:(?:\+|00)?(55)\s?)?(?:\(?([1-9][0-9])\)?\s?)?(?:((?:9\d|[2-9])\d{3})\-?(\d{4}))$';
    RegExp regex = new RegExp(pattern);
    if (text == null || !regex.hasMatch(text))
      return getString(_context, "validation_invalid_phone",
          defaultText: "Invalid phone");
    else
      return null;
  }

  @override
  String? validateLandlinePhone(String? text) {
    String pattern =
        r'^(?:(?:\+|00)?(55)\s?)?(?:\(?([1-9][0-9])\)?\s?)?(?:([2-5]\d{3})\-?(\d{4}))$';
    RegExp regex = new RegExp(pattern);
    if (text == null || !regex.hasMatch(text))
      return getString(_context, "validation_invalid_landline",
          defaultText: "Invalid landline");
    else
      return null;
  }

  @override
  String? validateRequired(String? text) {
    if (text != null && text.isNotEmpty) {
      return null;
    }
    if (kIsWeb) {
      return "Este campo é obrigatório";
    }

    return getString(_context, "validation_required",
        defaultText: "This field is required");
  }

  @override
  String? validateExisting(data) {
    if (data != null) {
      if (data is String && data.isEmpty) {
        return getString(_context, "validation_required",
            defaultText: "This field is required");
      }
      return null;
    }
    return getString(_context, "validation_required",
        defaultText: "This field is required");
  }

  @override
  String? validateCNPJ(String? text) {
    var validate = validateRequired(text);
    if (validate != null) {
      return validate;
    }

    final expectedLength = 14;
    var numbers = text?.replaceAll(RegExp(r'[\.\-\/]'), '');

    validate = validateExactLength(numbers, expectedLength);
    if (validate != null) {
      return validate;
    }

    var digits = RegExp(r'\d')
        .allMatches(numbers!)
        .map((it) => int.parse(numbers.substring(it.start, it.end)))
        .toList();

    if (digits.length == expectedLength && digits.toSet().length > 1) {
      var calcDv1 = 0;
      var j = 0;
      for (var i in Iterable<int>.generate(12, (i) => i < 4 ? 5 - i : 13 - i)) {
        calcDv1 += digits[j++] * i;
      }
      calcDv1 %= 11;
      var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

      if (digits[12] == dv1) {
        var calcDv2 = 0;
        j = 0;
        for (var i
            in Iterable<int>.generate(13, (i) => i < 5 ? 6 - i : 14 - i)) {
          calcDv2 += digits[j++] * i;
        }
        calcDv2 %= 11;
        var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

        if (digits[13] == dv2) {
          return null;
        }
      }
    }
    return getString(_context, "validation_invalid_cnpj",
        defaultText: "Invalid CNPJ");
  }

  @override
  String? validateCPF(String? text) {
    if (text == null) {
      return getString(_context, "validation_invalid_cpf",
          defaultText: "Invalid CPF");
    }
    var validate = validateRequired(text);
    if (validate != null) {
      return validate;
    }

    final expectedLength = 11;
    var numbers = text.replaceAll(RegExp(r'[\.\-]'), '');

    validate = validateExactLength(numbers, expectedLength);
    if (validate != null) {
      return validate;
    }

    var digits = RegExp(r'\d')
        .allMatches(numbers)
        .map((it) => int.parse(numbers.substring(it.start, it.end)))
        .toList();

    if (digits.length == expectedLength && digits.toSet().length > 1) {
      var calcDv1 = 0;
      for (var i in Iterable<int>.generate(9, (i) => 10 - i)) {
        calcDv1 += digits[10 - i] * i;
      }
      calcDv1 %= 11;
      var dv1 = calcDv1 < 2 ? 0 : 11 - calcDv1;

      if (digits[9] == dv1) {
        var calcDv2 = 0;
        for (var i in Iterable<int>.generate(10, (i) => 11 - i)) {
          calcDv2 += digits[11 - i] * i;
        }
        calcDv2 %= 11;
        var dv2 = calcDv2 < 2 ? 0 : 11 - calcDv2;

        if (digits[10] == dv2) {
          return null;
        }
      }
    }

    if (kIsWeb) {
      return "CPF inválido";
    } else {
      return getString(_context, "validation_invalid_cpf",
          defaultText: "Invalid CPF");
    }
  }

  @override
  String? validateCPForCNPJ(String? text, {bool optional = false}) {
    if (optional && (text == null || text == "" || text.length == 0))
      return null;

    var numbers = text!.replaceAll(RegExp(r'[\.\-]'), '');
    if (numbers.length > 11) {
      return validateCNPJ(text);
    } else {
      return validateCPF(text);
    }
  }

  @override
  String? validateDate(String? text, {bool optional = false}) {
    if (optional && text == "") return null;
    final dateFormat = DateFormat.yMd();
    try {
      dateFormat.parseStrict(text ?? "");
      return null;
    } catch (ex) {
      return getString(_context, "validation_invalid_date",
          defaultText: "Invalid Date");
    }
  }

  @override
  String? validateDateBeforeToday(String? text, {bool optional = false}) {
    if (optional && text == "") return null;
    final dateFormat = DateFormat.yMd();
    try {
      var date = dateFormat.parseStrict(text ?? "");
      if (date.isAfter(DateTime.now()))
        return getString(_context, "validation_invalid_date",
            defaultText: "Invalid Date");
      return null;
    } catch (ex) {
      return getString(_context, "validation_invalid_date",
          defaultText: "Invalid Date");
    }
  }

  @override
  String? validateTime(String text) {
    final dateFormat = DateFormat.jm();
    try {
      dateFormat.parseStrict(text);
      return null;
    } catch (ex) {
      return getString(_context, "validation_invalid_time",
          defaultText: "Horário inválido");
    }
  }

  @override
  String? validatePositiveValue(String text) {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    try {
      double valor = formatCurrency.parse(text) as double;
      if (valor > 0.00) {
        return null;
      }
      return getString(_context, "validation_invalid_value",
          defaultText: "This field must be greater than 0.00");
    } catch (ex) {
      return getString(_context, "validation_invalid_value",
          defaultText: "This field must be greater than 0.00");
    }
  }

  @override
  String? validateRequiredWithoutText(String? text) {
    if (text != null && text.isNotEmpty) {
      return null;
    }
    return "";
  }

  @override
  String? validateHourMinute(String text, bool valid) {
    final dateFormat = DateFormat.Hm();
    if (!valid) {
      return null;
    }
    if (text.length < 5) {
      return 'Horário inválido';
    }
    try {
      dateFormat.parseStrict(text);
      return null;
    } catch (ex) {
      return getString(_context, "validation_invalid_time",
          defaultText: "Horário inválido");
    }
  }

  @override
  String? validatePassport(String? text) {
    var validate = validateRequired(text);
    if (validate != null) {
      return validate;
    }
    if (text!.length < 7) {
      return validateMinLength(text, 7);
    } else if (text.length > 10) {
      return validateMaxLength(text, 10);
    } else {
      return null;
    }
  }

  @override
  String? validateRNE(String? text) {
    var txt = text!.replaceAll(RegExp(r'[\.\-]'), '');
    return validateExactLength(txt, 8);
  }
}
