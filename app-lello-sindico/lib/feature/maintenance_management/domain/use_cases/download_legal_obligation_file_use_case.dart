import 'package:cross_file/cross_file.dart';
import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../repository/maintenance_management_repository.dart';

class DownloadLegalObligationFileRequest {
  final String id;
  final String type;

  DownloadLegalObligationFileRequest({
    required this.id,
    required this.type,
  });
}

abstract class DownloadLegalObligationFileUseCase
    extends UseCase<XFile, DownloadLegalObligationFileRequest> {}

class DownloadLegalObligationFileUseCaseImpl
    implements DownloadLegalObligationFileUseCase {
  final MaintenanceManagementRepository repository;

  DownloadLegalObligationFileUseCaseImpl(this.repository);

  @override
  Future<Try<XFile>> call(DownloadLegalObligationFileRequest request) {
    return repository.downloadLegalObligationFile(request.id, request.type);
  }
}
