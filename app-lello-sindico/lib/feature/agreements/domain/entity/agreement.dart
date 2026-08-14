import 'dart:core';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';

class Agreement {
  String? id;
  int reference;
  String? unit;
  String? unitOwner;
  double baseValue;
  double fineAndCosts;
  int installmentQuantity;
  String? paymentMethod;
  String? status;
  DateTime? proposaldedDate;
  DateTime? approvalDate;
  int dueDate;
  DateTime? lastInstallmentDate;
  List<AgreementInstallment> installments;
  List<AgreementQuote> quotes;
  String? notificationParameter;

  Agreement({
    this.id,
    this.reference = 0,
    this.unit,
    this.unitOwner,
    this.baseValue = 0.0,
    this.fineAndCosts = 0.0,
    this.installmentQuantity = 0,
    this.paymentMethod,
    this.status,
    this.proposaldedDate,
    this.approvalDate,
    this.dueDate = 0,
    this.lastInstallmentDate,
    this.installments = const [],
    this.quotes = const [],
    this.notificationParameter,
  });

  String get unitAndNameDescription {
    if (unit != null && unitOwner != null) {
      return "$unit - ${unitOwner!.toUpperCase()}";
    }
    if (unit == null && unitOwner != null) {
      return "${unitOwner!.toUpperCase()}";
    }
    if (unit != null && unitOwner == null) {
      return "$unit";
    }
    return "";
  }

  double get totalValue {
    return baseValue + fineAndCosts;
  }

  String get getTotalValueFormatted {
    String total = "";
    total = totalValue.toStringAsFixed(2).replaceAll('.', ',');
    if (totalValue >= 1000) {
      total =
          "${total.substring(0, total.length - 6)}.${total.substring(total.length - 6, total.length)}";
    }
    total = "R\$ $total";
    return total;
  }

  double get getAmountReceivable {
    double amountValue = 0.0;
    installments.forEach((element) {
      if (element.status == AgreementInstallmentsStatus.pending) {
        amountValue = amountValue + element.value;
      }
    });
    return amountValue;
  }

  String get getPendingOverTotalInstallments {
    int pendingInstallments = 0;
    String totalInstallments = installments.length.toString();
    installments.forEach((element) {
      if (element.status == AgreementInstallmentsStatus.pending) {
        pendingInstallments = pendingInstallments + 1;
      }
    });
    return "$pendingInstallments/$totalInstallments";
  }

  String get getApprovalDate {
    if (approvalDate != null) {
      final dateFormat = new DateFormat('dd/MM/yyyy');
      return dateFormat.format(approvalDate!);
    }
    return "-";
  }

  String get getProposalDate {
    if (proposaldedDate != null) {
      final dateFormat = new DateFormat('dd/MM/yyyy');
      return dateFormat.format(proposaldedDate!);
    }
    return "-";
  }

  String get getPaymentMethodKey =>
      PaymentMethod.getPaymentMethodKey(paymentMethod);

  String get getStatusKey => AgreementStatus.getStatusKey(status);

  Color getStatusColor(ThemeData theme) =>
      AgreementStatus.getStatusColor(theme, status);

  String get getInstallmentsAndValue {
    if (installments.isEmpty && installmentQuantity != 0) {
      String value = (totalValue / installmentQuantity)
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      return "[${installmentQuantity}x] R\$ $value";
    }
    if (installments.isNotEmpty) {
      String value =
          installments.first.value.toStringAsFixed(2).replaceAll('.', ',');
      return "[${installments.length}x] R\$ $value";
    }

    return "-";
  }

  String get getExpirationDay {
    if (dueDate != 0) {
      return "$dueDate";
    }
    return "-";
  }

  String getDateMonthWritten(
    BuildContext context, {
    bool onlyMonthYear = false,
  }) {
    DateTime? dateTime;
    String month = "";
    String date = "";
    if (approvalDate != null) {
      dateTime = approvalDate;
    } else if (proposaldedDate != null) {
      dateTime = proposaldedDate;
    }
    if (dateTime != null) {
      switch (dateTime.month) {
        case (1):
          month = getString(context, "january");
          break;
        case (2):
          month = getString(context, "february");
          break;
        case (3):
          month = getString(context, "march");
          break;
        case (4):
          month = getString(context, "april");
          break;
        case (5):
          month = getString(context, "may");
          break;
        case (6):
          month = getString(context, "june");
          break;
        case (7):
          month = getString(context, "july");
          break;
        case (8):
          month = getString(context, "august");
          break;
        case (9):
          month = getString(context, "september");
          break;
        case (10):
          month = getString(context, "october");
          break;
        case (11):
          month = getString(context, "november");
          break;
        case (12):
          month = getString(context, "december");
          break;
      }

      date = onlyMonthYear
          ? "${month[0].toUpperCase()}${month.substring(1)}/${dateTime.year}"
          : "${dateTime.day} de $month, ${dateTime.year}";

      return date;
    }
    return "";
  }
}
