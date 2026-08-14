import 'package:lello/feature/payment/data/model/payment_approval_model.dart';

abstract class PaymentApprovalRemoteDataSource {
	Future<PaymentApprovalModel> insert(String condominiumId, PaymentApprovalModel paymentApproval);
}