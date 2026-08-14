import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';

abstract class FindPaymentByBarcode
    extends UseCase<Payment?, FindPaymentByBarcodeParam> {}

class FindPaymentByBarcodeParam {
  final String condominiumId;
  final String barcode;
  FindPaymentByBarcodeParam(
      {required this.condominiumId, required this.barcode});
}
