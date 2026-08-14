
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementInstallmentsStatus {
  static const pending = "pending";
  static const paid = "paid";
  static const canceled = "canceled";

  static List<String> get getList => [
        pending,
        paid,
        canceled,
      ];

  static String getStatusKey(String? status) {
    switch (status) {
      case AgreementInstallmentsStatus.pending:
        return "agreements_installment_pendency";
      case AgreementInstallmentsStatus.paid:
        return "agreements_installment_paid";
      case AgreementInstallmentsStatus.canceled:
        return "agreements_installment_cancelled";
      default:
        return "";
    }
  }

  static Color getStatusColor(ThemeData theme, String? status) {
    switch (status) {
      case pending:
        return LelloTheme.palleteOf(theme).warning();
      case paid:
        return LelloTheme.palleteOf(theme).success();
      case canceled:
        return LelloTheme.palleteOf(theme).error();
      default:
        return LelloTheme.palleteOf(theme).primary();
    }
  }
}
