import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode.dart';

class FindPaymentByBarcodeImpl extends FindPaymentByBarcode {
  final PaymentRepository repository;

  FindPaymentByBarcodeImpl({required this.repository});

  @override
  Future<Try<Payment?>> call(FindPaymentByBarcodeParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.findByBarcode(params.condominiumId, params.barcode);
  }

  Failure? _validate(FindPaymentByBarcodeParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.barcode.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
