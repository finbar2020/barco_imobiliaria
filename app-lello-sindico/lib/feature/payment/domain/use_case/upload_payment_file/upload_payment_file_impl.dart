import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/repository/payment_file_repository.dart';
import 'package:lello/feature/payment/domain/use_case/upload_payment_file/upload_payment_file.dart';

class UploadPaymentFileImpl extends UploadPaymentFile {
  final PaymentFileRepository uploader;

  UploadPaymentFileImpl({required this.uploader});
  @override
  Future<Try<String>> call(UploadPaymentFileParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await uploader.upload(params.condominiumId, params.file,
        onComplete: (v) {}, onError: (v) {});
  }

  Failure? _validate(UploadPaymentFileParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
