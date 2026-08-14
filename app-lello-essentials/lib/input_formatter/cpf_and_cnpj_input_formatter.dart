import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'input_formatter_preset.dart';

class CpfOrCnpjInputFormatter extends TextInputFormatter {
  MaskTextInputFormatter cpf = cpfFormatter();
  MaskTextInputFormatter cnpj = cnpjFormatter();
  MaskTextInputFormatter? current;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (current == null) current = cpf;
    final number = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (number.length == 11) {
      current = cpfFormatter();

      return current!.formatEditUpdate(TextEditingValue(), newValue);
    } else if (number.length > 11 && number.length <= 14) {
      current = cnpjFormatter();

      return current!.formatEditUpdate(TextEditingValue(), newValue);
    }

    return current!.formatEditUpdate(oldValue, newValue);
  }
}
