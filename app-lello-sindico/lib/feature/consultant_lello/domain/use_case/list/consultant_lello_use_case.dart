import 'package:essentials/essentials.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';

abstract class ConsultantUseCase extends UseCase<ConsultantEntity, ConsultantParms> {}

class ConsultantParms {
  final String condominiumId;
  ConsultantParms({required this.condominiumId});
}
