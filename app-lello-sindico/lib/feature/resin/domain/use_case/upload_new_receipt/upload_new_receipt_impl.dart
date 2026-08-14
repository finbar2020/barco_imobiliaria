import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/repository/resin_repository.dart';
import 'package:lello/feature/resin/domain/use_case/upload_new_receipt/upload_new_receipt.dart';

class UploadNewReceiptImpl extends UploadNewReceipt {
  final ResinRepository repository;

  UploadNewReceiptImpl({required this.repository});

  @override
  Future<Try<ResinRefundReceipt>> call(UploadNewReceiptParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.uploadNewReceipt(
        params.condominiumId, params.refundId, params.receipt);
  }

  Failure? _validate(UploadNewReceiptParams? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    if (param.refundId.isEmpty) return InvalidParamFailure();

    return null;
  }
}
