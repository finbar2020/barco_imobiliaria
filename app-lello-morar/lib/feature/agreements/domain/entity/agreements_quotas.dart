import 'package:intl/intl.dart';

class AgreementQuota {
  String id;
  String receipt;
  double originValue;
  DateTime dueDate;
  double fineValue;
  double feeValue;
  double honoraryValue;
  String overdueMessage;

  AgreementQuota({
    required this.id,
    required this.receipt,
    required this.originValue,
    required this.dueDate,
    required this.fineValue,
    required this.feeValue,
    required this.honoraryValue,
    required this.overdueMessage,
  });

  String get date => DateFormat("dd/MM/yyyy").format(dueDate);

  String get origin {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency.format(originValue);
  }

  String get fee {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency.format(fineValue + feeValue + honoraryValue);
  }

  String get total {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency
        .format(fineValue + feeValue + honoraryValue + originValue);
  }

  double get valorTotal => fineValue + feeValue + honoraryValue + originValue;

  String get daysRemanining =>
      DateTime.now().difference(dueDate).inDays.toString();
}
