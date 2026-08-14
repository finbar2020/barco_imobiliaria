import 'package:intl/intl.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';

class AgreementsInProgress {
  List<Agreement> agreements;

  AgreementsInProgress({
    required this.agreements,
  });

  String get getAmountReceivable {
    String amount = "";
    double amountValue = 0.0;
    agreements.forEach((element) {
      amountValue = amountValue + element.getAmountReceivable;
    });
    amount = amountValue.toStringAsFixed(2).replaceAll('.', ',');
    if (amountValue >= 1000) {
      amount =
          "${amount.substring(0, amount.length - 6)}.${amount.substring(amount.length - 6, amount.length)}";
    }
    amount = "R\$ $amount";
    return amount;
  }

  String get getLastInstallment {
    DateTime? lastInstallment;
    if (agreements.isNotEmpty) {
      lastInstallment = agreements.first.lastInstallmentDate ?? DateTime.now();
      agreements.forEach((element) {
        if (element.lastInstallmentDate != null) {
          if (element.lastInstallmentDate!.isAfter(lastInstallment!)) {
            lastInstallment = element.lastInstallmentDate!;
          }
        }
      });
    }
    if (lastInstallment != null) {
      final dateFormat = new DateFormat('dd/MM/yyyy');
      return dateFormat.format(lastInstallment!);
    }
    return "-";
  }
}
