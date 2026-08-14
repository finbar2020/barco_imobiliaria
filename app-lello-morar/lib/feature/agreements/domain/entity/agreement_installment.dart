import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementInstallment {
  String? readableLine;
  String? barCode;
  String? installmentId;
  String? recnum;
  double? value;
  DateTime? dueDate;
  String? status;
  String? paymentLink;

  AgreementInstallment({
    this.readableLine,
    this.barCode,
    this.installmentId,
    this.recnum,
    this.value,
    this.dueDate,
    this.status,
    this.paymentLink,
  });

  Color getStatusColor(ThemeData theme) {
    switch (status) {
      case "pending":
        return LelloTheme.palleteOf(theme).warning();
      case "paid":
        return LelloTheme.palleteOf(theme).success();
      case "calceled":
        return LelloTheme.palleteOf(theme).textOpaque();
      default:
        return theme.primaryColor;
    }
  }

  String getStatusInfo(BuildContext context) {
    switch (status) {
      case "pending":
        return getString(context, "space_reserved_waiting");
      case "paid":
        return getString(context, "income_billet_detail_situation_paid_out");
      case "calceled":
        return getString(context, "income_billet_detail_situation_canceled");
      default:
        return "";
    }
  }
}
