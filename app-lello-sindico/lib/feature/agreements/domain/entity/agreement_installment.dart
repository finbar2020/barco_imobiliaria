
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';

class AgreementInstallment {
  String? installmentId;
  double value;
  DateTime? dueDate;
  String? status;

  AgreementInstallment({
    this.installmentId,
    this.value = 0.0,
    this.dueDate,
    this.status,
  });

  String get getStatusKey => AgreementInstallmentsStatus.getStatusKey(status);

  Color getStatusColor(ThemeData theme) =>
      AgreementInstallmentsStatus.getStatusColor(theme, status);
}
