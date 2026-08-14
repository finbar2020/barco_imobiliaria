import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_all_info.dart';

abstract class GetAllAgreementsInfoUseCase
    extends UseCase<AgreementsAllInfo?, GetAllAgreementsInfoParams> {}

class GetAllAgreementsInfoParams {
  final String condominiumId;
  final DataOrigin origin;

  GetAllAgreementsInfoParams({
    required this.condominiumId,
    required this.origin,
  });
}
