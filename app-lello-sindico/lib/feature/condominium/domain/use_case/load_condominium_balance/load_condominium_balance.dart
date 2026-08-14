import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';

abstract class LoadCondominiumBalance
    extends UseCase<CondominiumBalance?, CondominiumBalanceParam> {}

class CondominiumBalanceParam {
  final String id;
  final String reference;
  final DataOrigin origin;

  CondominiumBalanceParam(
      {required this.id, required this.reference, required this.origin});
}
