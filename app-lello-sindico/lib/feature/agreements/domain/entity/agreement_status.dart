import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class AgreementStatus {
  static const pending = "pending";
  static const approvedByManager = "approved_by_manager";
  static const approvedAutomatically = "approved_automatically";
  static const rejected = "rejected";
  static const canceledAutomatically = "canceled_automatically";
  static const completed = "completed";
  static const cancelled = "cancelled";

  static List<String> get getList => [
        pending,
        approvedByManager,
        approvedAutomatically,
        rejected,
        canceledAutomatically,
        completed,
        cancelled,
      ];

  static String getStatusKey(String? status) {
    switch (status) {
      case pending:
        return "agreements_pendency";
      case approvedByManager:
        return "agreements_approved_by_manager";
      case approvedAutomatically:
        return "agreements_automatically_approved";
      case rejected:
        return "agreements_rejected";
      case canceledAutomatically:
        return "agreements_rejected";
      case completed:
        return "agreements_completed";
      case cancelled:
        return "agreements_cancelled";

      default:
        return "";
    }
  }

  static Color getStatusColor(ThemeData theme, String? status) {
    switch (status) {
      case pending:
        return LelloTheme.palleteOf(theme).warning();
      case approvedByManager:
        return LelloTheme.palleteOf(theme).warning();
      case approvedAutomatically:
        return LelloTheme.palleteOf(theme).warning();
      case rejected:
        return LelloTheme.palleteOf(theme).error();
      case canceledAutomatically:
        return LelloTheme.palleteOf(theme).error();
      case completed:
        return LelloTheme.palleteOf(theme).success();
      case cancelled:
        return LelloTheme.palleteOf(theme).error();
      default:
        return LelloTheme.palleteOf(theme).text();
    }
  }
}
