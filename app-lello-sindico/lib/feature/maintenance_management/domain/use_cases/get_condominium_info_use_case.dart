import 'package:essentials/base/use_case.dart';
import 'package:essentials/functional/try.dart';

import '../entity/maintenance_management_entity.dart';
import '../repository/maintenance_management_repository.dart';

abstract class GetCondominiumInfoUseCase
    extends UnitUseCase<CondominiumInfoEntity> {}

/// Busca as informações do condomínio utilizando o endpoint V2 (`X-Session-Version: v2`).
///
/// Conforme GO-52, o APP deve sempre enviar o header de sessão V2 para obter
/// os dados enriquecidos (token TT, idSession, admin, profileId, etc.).
class GetCondominiumInfoUseCaseImpl implements GetCondominiumInfoUseCase {
  final MaintenanceManagementRepository repository;

  GetCondominiumInfoUseCaseImpl(this.repository);

  @override
  Future<Try<CondominiumInfoEntity>> call() =>
      repository.getCondominiumInfoV2();
}

