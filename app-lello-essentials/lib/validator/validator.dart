import 'package:flutter/material.dart';

abstract class Validator {
  set context(BuildContext context);
  String? validateEmail(String? text);
  String? validateCPF(String? text);
  String? validateCNPJ(String? text);
  String? validateCPForCNPJ(String? text, {bool optional});
  String? validateCellPhone(String? text);
  String? validateLandlinePhone(String? text);
  String? validatePassword(String? text);
  String? validateRequired(String? text);
  String? validateTime(String text);
  String? validateExisting(data);
  String? validateMinLength(String? text, int minLength);
  String? validateMaxLength(String? text, int maxLength);
  String? validateExactLength(String? text, int length);
  String? validateDate(String? text, {bool optional});
  String? validateDateBeforeToday(String? text, {bool optional = false});
  String? validatePositiveValue(String text);
  String? validateRequiredWithoutText(String? text);
  String? validateHourMinute(String text, bool valid);
  String? validateRNE(String? text);
  String? validatePassport(String? text);
}
