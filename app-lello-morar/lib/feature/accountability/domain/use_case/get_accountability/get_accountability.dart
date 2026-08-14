import 'package:essentials/essentials.dart';
import 'package:morar/feature/accountability/domain/entity/accountability.dart';

abstract class GetAccountability
    extends UseCase<Accountability, GetAccountabilityParam> {}

class GetAccountabilityParam {
  final String condominiumId;
  final DateTime period;

  GetAccountabilityParam({required this.condominiumId, required this.period});
}
