import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountabilityPeriods {
  DateTime period;
  String situation;
  DateTime? approvalDate;
  DateTime? initialPeriod;
  DateTime? endingPeriod;

  AccountabilityPeriods({
    required this.period,
    required this.situation,
    required this.approvalDate,
    this.initialPeriod,
    this.endingPeriod,
  });
  bool get isAproved => situation == "APROVADA";

  Color get getDropColor => isAproved ? Colors.green : Colors.orange;

  String get getFormattedDate =>
      (approvalDate == null ? "" : DateFormat.yMd().format(approvalDate!));
}
