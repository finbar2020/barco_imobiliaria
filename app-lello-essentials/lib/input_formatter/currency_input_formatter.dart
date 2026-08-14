import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final bool showSymbol;
  CurrencyInputFormatter({this.showSymbol = true});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final string = newValue.text;

    var moneyStr = string.replaceAll(RegExp(r"\D"), "");
    if (moneyStr.length > 16) moneyStr = moneyStr.substring(0, 16);
    final money = int.parse(moneyStr) / 100;
    final formatCurrency = NumberFormat.currency(symbol: "");
    final symbol = showSymbol ? "R\$" : "";
    final text = "$symbol${formatCurrency.format(money)}";
    return TextEditingValue(
        text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
