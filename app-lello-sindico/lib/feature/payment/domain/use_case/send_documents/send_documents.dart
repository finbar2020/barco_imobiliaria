import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';

abstract class SendDocuments
    extends UseCase<ProcessFilesResponseEntity, SendDocumentsParams> {}

class SendDocumentsParams {
  final String condoId;
  final List<String> fileUrls;

  SendDocumentsParams({
    required this.condoId,
    required this.fileUrls,
  });
}
