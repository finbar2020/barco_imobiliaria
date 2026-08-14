import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_api.dart';
import 'package:lello/feature/payment/data/data_source/approval/payment_approval_remote_data_source.dart';
import 'package:lello/feature/payment/data/model/payment_approval_model.dart';

class PaymentApprovalRemoteDataSourceImpl
    extends PaymentApprovalRemoteDataSource {
  final PaymentApprovalApi api;

  PaymentApprovalRemoteDataSourceImpl({required this.api});

  @override
  Future<PaymentApprovalModel> insert(
      String condominiumId, PaymentApprovalModel paymentApproval) async {
    final response = await api.post(
        condominiumId, paymentApproval.paymentId!, paymentApproval);
    return ApiMapper.map(
        response, (json) => PaymentApprovalModel.fromJson(json));
  }
}
