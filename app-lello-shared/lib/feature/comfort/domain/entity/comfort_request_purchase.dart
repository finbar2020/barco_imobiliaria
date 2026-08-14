import 'package:intl/intl.dart';

class ComfortRequestPurchase {
  String requestId;
  String userId;
  String unitId;
  bool purchaseDone;
  int? usedCoupon;
  double? rating;
  String? comment;
  DateTime? purchaseDate;
  DateTime? dateResend;
  String? typeCTA;
  bool? canCancel;
  bool? canResend;
  String? status;
  String? typeSubject;

  ComfortRequestPurchase(
      {required this.requestId,
      required this.userId,
      required this.unitId,
      required this.purchaseDone,
      this.usedCoupon,
      this.rating,
      this.comment,
      this.purchaseDate,
      this.dateResend,
      this.typeCTA,
      this.status,
      this.canCancel = false,
      this.canResend = false,
      this.typeSubject});

  String get formattedPurchaseDate {
    if (purchaseDate == null) {
      return "";
    }
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.format(purchaseDate!);
  }
}
