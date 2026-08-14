import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/domain/repository/payment_process_file_repository.dart';
import 'package:lello/feature/payment/domain/use_case/send_documents/send_documents.dart';

class SendDocumentsImpl extends SendDocuments {
  final PaymentProcessFileRepository repository;

  SendDocumentsImpl({required this.repository});

  @override
  Future<Try<ProcessFilesResponseEntity>> call(
      SendDocumentsParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.processFiles(params.condoId, params.fileUrls);
  }

  Failure? _validate(SendDocumentsParams? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condoId.isEmpty) return InvalidParamFailure();
    if (params.fileUrls.isEmpty) return InvalidParamFailure();
    return null;
  }
}
