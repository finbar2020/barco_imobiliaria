import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/reigster_payment_failure.dart';

class RegisterPaymentImpl extends RegisterPayment {
  final PaymentRepository repository;
  RegisterPaymentImpl({required this.repository});

  @override
  Future<Try<Payment?>> call(RegisterPaymentParams params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    return await repository.insert(
      params.condominiumId,
      params.payment,
    );
  }

  Failure? validate(RegisterPaymentParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.payment.supplierIdentification?.isEmpty != false ||
        params.payment.supplierName?.isEmpty != false)
      return RegisterPaymentInvalidSupplierFailure();
    if (params.payment.documentNumber?.isEmpty != false)
      return RegisterPaymentInvalidDocumentFailure();
    if (params.payment.totalValue <= 0)
      return RegisterPaymentInvalidValueFailure();
    if (params.payment.hasInstallments == true &&
        !params.payment.equalInstallments &&
        params.payment.installments.length == 0)
      return RegisterPaymentInvalidInstallmentsFailure();

    return null;
  }
}
