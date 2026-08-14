import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet.dart';

abstract class GetBillets extends UseCase<Billet?, GetBilletsParam> {}

class GetBilletsParam {
  final String condominiumId;
  final String unitId;
  final DateTime period;

  GetBilletsParam({
    required this.condominiumId,
    required this.unitId,
    required this.period,
  });
}
