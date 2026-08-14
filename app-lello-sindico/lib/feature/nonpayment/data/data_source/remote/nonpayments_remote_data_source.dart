import 'package:lello/feature/nonpayment/data/model/nonpayments_model.dart';

abstract class NonPaymentsRemoteDataSource {
  Future<NonPaymentModel> get(String condominiumId, String period);
}