import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgreementQuote {
  String? id;
  DateTime? dueDate;
  double originValue;
  double fineValue;
  double feeValue;
  double honoraryValue;
  String? overdueMessage;

  AgreementQuote({
    this.id,
    this.dueDate,
    this.originValue = 0.0,
    this.fineValue = 0.0,
    this.feeValue = 0.0,
    this.honoraryValue = 0.0,
    this.overdueMessage,
  });

  double get fines {
    return fineValue + feeValue + honoraryValue;
  }

  String get getTotalValue {
    String value =
        (originValue + fines).toStringAsFixed(2).replaceAll('.', ',');
    return "R\$ $value";
  }

  String get getOriginValue {
    String value = originValue.toStringAsFixed(2).replaceAll('.', ',');
    return "R\$ $value";
  }

  String get getFinesValue {
    String value = fines.toStringAsFixed(2).replaceAll('.', ',');
    return "R\$ $value";
  }

  String get getDate {
    final dateFormat = new DateFormat('dd/MM/yyyy');
    if (dueDate != null) {
      return dateFormat.format(dueDate!);
    } else {
      return "";
    }
  }

  String getMonthYear(BuildContext context) {
    String month = "";
    String date = "";
    if (dueDate == null) {
      return "";
    }
    switch (dueDate!.month) {
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
    if (month.length > 3) {
      month = month.substring(0, 3).toUpperCase();
    }
    date = "$month, ${dueDate!.year}";
    return date;
  }
}
