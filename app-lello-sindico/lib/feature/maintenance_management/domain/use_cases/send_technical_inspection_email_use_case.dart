import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../repository/maintenance_management_repository.dart';

class SendTechnicalInspectionEmailRequest {
  final String type;
  final String id;
  final String email;

  const SendTechnicalInspectionEmailRequest({
    required this.type,
    required this.id,
    required this.email,
  });
}

abstract class SendTechnicalInspectionEmailUseCase
    extends UseCase<bool, SendTechnicalInspectionEmailRequest> {}

class SendTechnicalInspectionEmailUseCaseImpl
    implements SendTechnicalInspectionEmailUseCase {
  final MaintenanceManagementRepository repository;

  SendTechnicalInspectionEmailUseCaseImpl(this.repository);

  @override
  Future<Try<bool>> call(SendTechnicalInspectionEmailRequest request) {
    return repository.sendTechnicalInspectionEmail(
      type: request.type,
      id: request.id,
      email: request.email,
    );
  }
}
