import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../repository/maintenance_management_repository.dart';

class RequestLegalObligationRenewalRequest {
  final String type;
  final String id;

  const RequestLegalObligationRenewalRequest({
    required this.type,
    required this.id,
  });
}

abstract class RequestLegalObligationRenewalUseCase
    extends UseCase<bool, RequestLegalObligationRenewalRequest> {}

class RequestLegalObligationRenewalUseCaseImpl
    implements RequestLegalObligationRenewalUseCase {
  final MaintenanceManagementRepository repository;

  RequestLegalObligationRenewalUseCaseImpl(this.repository);

  @override
  Future<Try<bool>> call(RequestLegalObligationRenewalRequest request) {
    return repository.requestLegalObligationRenewal(
      type: request.type,
      id: request.id,
    );
  }
}
