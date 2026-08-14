import 'package:essentials/essentials.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance_detail_filter.dart';

abstract class LoadCondominiumBalanceDetail extends UseCase<
    CondominiumBalanceDetail?, LoadCondominiumBalanceDetailParam> {}

class LoadCondominiumBalanceDetailParam {
  final String condominiumId;
  final String reference;
  final CondominiumBalanceDetailFilter? filter;
  final DataOrigin origin;

  LoadCondominiumBalanceDetailParam(
      {required this.condominiumId,
      required this.reference,
      this.filter,
      required this.origin});
}
