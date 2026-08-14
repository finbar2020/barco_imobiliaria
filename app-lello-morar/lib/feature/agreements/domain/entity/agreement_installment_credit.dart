import 'package:intl/intl.dart';

class AgreementInstallmentCredit {
  double billetValue;
  double installmentQtd;
  double? tax;
  double totalValue;
  double installmentValue;
  String? cetMonth;
  String? cetTotal;
  String? creditTax;
  double? creditTaxValue;

  AgreementInstallmentCredit({
    required this.billetValue,
    required this.installmentQtd,
    required this.totalValue,
    required this.installmentValue,
    this.tax,
    this.cetMonth,
    this.cetTotal,
    this.creditTax,
    this.creditTaxValue,
  });

  String get installment {
    var number = installmentQtd.toInt();
    return number.toString();
  }

  String get taxValue {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    var sum = billetValue / 100 * (tax ?? 1);
    return formatCurrency.format(sum);
  }
}
