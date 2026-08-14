import 'package:flutter/material.dart';

enum PaymentHistoryItemStatus {
  paid,
  accounted,
  canceled,
  suspended,
  progress,
}

String paymentHistoryItemStatusToString(
    BuildContext context, PaymentHistoryItemStatus status) {
  switch (status) {
    case PaymentHistoryItemStatus.paid:
      return "Pago";
    case PaymentHistoryItemStatus.accounted:
      return "Contabilizado";
    case PaymentHistoryItemStatus.canceled:
      return "Cancelado";
    case PaymentHistoryItemStatus.suspended:
      return "Suspenso";
    case PaymentHistoryItemStatus.progress:
      return "Em Andamento";
  }
}
