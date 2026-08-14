import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../enum/legal_obligation_type.dart';
import '../entity/legal_obligation_entity.dart';
import '../repository/maintenance_management_repository.dart';

class GetLegalObligationsRequest {
  final LegalObligationType type;

  const GetLegalObligationsRequest({required this.type});
}

abstract class GetLegalObligationsUseCase
    extends UseCase<LegalObligationEntity, GetLegalObligationsRequest> {}

class GetLegalObligationsUseCaseImpl implements GetLegalObligationsUseCase {
  final MaintenanceManagementRepository repository;

  GetLegalObligationsUseCaseImpl(this.repository);

  @override
  Future<Try<LegalObligationEntity>> call(GetLegalObligationsRequest request) =>
      repository.getLegalObligations(request.type);
}
