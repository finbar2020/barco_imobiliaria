import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/legal_obligation_upload_response_entity.dart';
import '../repository/maintenance_management_repository.dart';

class UploadLegalObligationFileRequest {
  final String type;
  final String id;
  final String fileName;
  final String fileUrl;
  final String date;

  UploadLegalObligationFileRequest({
    required this.type,
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.date,
  });
}

abstract class UploadLegalObligationFileUseCase
    extends UseCase<LegalObligationUploadResponseEntity, UploadLegalObligationFileRequest> {}

class UploadLegalObligationFileUseCaseImpl
    implements UploadLegalObligationFileUseCase {
  final MaintenanceManagementRepository repository;

  UploadLegalObligationFileUseCaseImpl(this.repository);

  @override
  Future<Try<LegalObligationUploadResponseEntity>> call(
      UploadLegalObligationFileRequest request) {
    return repository.uploadLegalObligationFile(
      type: request.type,
      id: request.id,
      fileName: request.fileName,
      fileUrl: request.fileUrl,
      date: request.date,
    );
  }
}
