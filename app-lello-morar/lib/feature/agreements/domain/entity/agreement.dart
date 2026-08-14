import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';

class Agreement {
  final String id;
  final String unit;
  final String unitOwner;
  final double baseValue;
  final double fineAndCosts;
  final String paymentMethod;
  final String expiration;
  final int installmentQuantity;
  final String proposaldedDate;
  final String? approvalDate;
  final String? agreementCodeAcob;
  final int reference;
  final DateTime? lastInstallmentDate;
  String status;
  final String statusMessage;
  final List<AgreementInstallment> installments;
  final List<AgreementQuota> quotes;
  String? reason;
  var baseUrl;
  String? notificationParameter;

  bool highlight = false;

  Agreement({
    required this.id,
    required this.unit,
    required this.unitOwner,
    required this.baseValue,
    required this.fineAndCosts,
    required this.paymentMethod,
    required this.expiration,
    required this.installmentQuantity,
    required this.proposaldedDate,
    this.approvalDate,
    this.agreementCodeAcob,
    required this.reference,
    this.lastInstallmentDate,
    required this.status,
    required this.statusMessage,
    required this.installments,
    required this.quotes,
    this.reason,
    this.baseUrl,
    this.notificationParameter,
  });

  String get date {
    var format = DateTime.parse(expiration);
    return DateFormat("dd/MM/yyyy").format(format);
  }

  String get base {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency.format(baseValue);
  }

  String get fine {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency.format(fineAndCosts);
  }

  String get total {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    return formatCurrency.format(baseValue + fineAndCosts);
  }

  Color getStatusColor(ThemeData theme) {
    switch (status) {
      case "pending":
        return LelloTheme.palleteOf(theme).warning();
      case "approved_by_manager":
        return LelloTheme.palleteOf(theme).success();
      case "approved_automatically":
        return LelloTheme.palleteOf(theme).success();
      case "completed":
        return LelloTheme.palleteOf(theme).success();
      case "rejected":
        return LelloTheme.palleteOf(theme).textOpaque();
      case "canceled_automatically":
        return LelloTheme.palleteOf(theme).textOpaque();
      case "cancelled":
        return LelloTheme.palleteOf(theme).textOpaque();
      default:
        return theme.primaryColor;
    }
  }

  bool get isReleased {
    if (status == "approved_by_manager" || status == "approved_automatically") {
      return true;
    } else {
      return false;
    }
  }

  bool get isPending {
    if (status == "pending") {
      return true;
    } else {
      return false;
    }
  }

  bool get isRejected {
    if (status == "rejected" || status == "canceled_automatically") {
      return true;
    } else {
      return false;
    }
  }

  String get getBarCode {
    var lista = this
        .installments
        .where((element) => element.status == "pending")
        .toList();
    var barcode = "";
    if (lista.isNotEmpty) {
      barcode = lista[0].readableLine ?? "";
    }
    return barcode;
  }

  String get installmentId {
    var lista = this
        .installments
        .where((element) => element.status == "pending")
        .toList();
    var id = "";
    if (lista.isNotEmpty) {
      id = lista[0].installmentId ?? "";
    }
    return id;
  }

  String getStatusInfo(BuildContext context) {
    switch (status) {
      case "pending":
        return getString(context, "agreement_pending_status");
      case "approved_by_manager":
        return getString(context, "agreement_payment_released");
      case "approved_automatically":
        return getString(context, "agreement_payment_released");
      case "completed":
        return getString(context, "agreement_end");
      case "rejected":
        return getString(context, "income_billet_detail_situation_canceled");
      case "canceled_automatically":
        return getString(context, "income_billet_detail_situation_canceled");
      case "cancelled":
        return getString(context, "income_billet_detail_situation_canceled");
      default:
        return "";
    }
  }

  String get getInstallments => statusMessage;

  String get newValue {
    final formatCurrency = new NumberFormat.currency(symbol: "R\$");
    var qtd = installmentQuantity == 0 ? 1 : installmentQuantity;
    var value = formatCurrency.format((baseValue + fineAndCosts) / qtd);
    return "[${qtd}X] $value";
  }

  String get newExpiration {
    var format = DateTime.parse(proposaldedDate);
    return DateFormat("dd/MM/yyyy").format(lastInstallmentDate ?? format);
  }

  String method(BuildContext context) => paymentMethod == "billet"
      ? getString(context, "income_billet_detail_billet")
      : getString(context, "agreements_credit");

  Uri? get getPaymentLink {
    if (installments.isEmpty) return null;
    var lista = this
        .installments
        .where((element) => element.status == "pending")
        .toList();
    String? url;
    if (lista.isNotEmpty) {
      url = lista[0].paymentLink;
    }
    if (url == null) return null;
    return Uri.tryParse(url);
  }
}
