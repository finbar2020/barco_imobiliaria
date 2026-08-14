import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';
import 'package:lello/feature/payment/domain/use_case/upload_documents_aws/upload_documents.dart';

class UploadDocumentsImpl extends UploadDocuments {
  final PaymentProcessFileRepository repository;

  UploadDocumentsImpl({required this.repository});

  @override
  Future<Try<String>> call(UploadDocumentsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.uploadFileToAws(params.file, params.url);
  }

  Failure? _validate(UploadDocumentsParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.url.isEmpty) return InvalidParamFailure();
    return null;
  }
}
