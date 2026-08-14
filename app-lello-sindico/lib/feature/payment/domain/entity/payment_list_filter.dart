// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/payment/domain/entity/payment_source.dart';

class PaymentListFilter {
  PaymentSource source;
  DateTime? createdDateFrom;
  DateTime? createdDateTo;
  String? entry;
  String? supplierIdentification;
  String? supplierName;
  String? documentNumber;
  double? value;
  DateTime? creationFrom;
  DateTime? creationTo;
  bool? forcePendencyStatus;

  PaymentListFilter({
    this.source = PaymentSource.all,
    this.createdDateFrom,
    this.createdDateTo,
    this.entry,
    this.supplierIdentification,
    this.supplierName,
    this.documentNumber,
    this.value,
    this.creationFrom,
    this.creationTo,
    this.forcePendencyStatus,
  });

  PaymentListFilter copyWith({
    PaymentSource? source,
    DateTime? createdDateFrom,
    DateTime? createdDateTo,
    String? entry,
    String? supplierIdentification,
    String? supplierName,
    String? documentNumber,
    double? value,
    DateTime? creationFrom,
    DateTime? creationTo,
    bool? forcePendencyStatus,
  }) {
    return PaymentListFilter(
      source: source ?? this.source,
      createdDateFrom: createdDateFrom ?? this.createdDateFrom,
      createdDateTo: createdDateTo ?? this.createdDateTo,
      entry: entry ?? this.entry,
      supplierIdentification:
          supplierIdentification ?? this.supplierIdentification,
      supplierName: supplierName ?? this.supplierName,
      documentNumber: documentNumber ?? this.documentNumber,
      value: value ?? this.value,
      creationFrom: creationFrom ?? this.creationFrom,
      creationTo: creationTo ?? this.creationTo,
      forcePendencyStatus: forcePendencyStatus ?? this.forcePendencyStatus,
    );
  }
}
