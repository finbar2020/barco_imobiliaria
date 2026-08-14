import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class GetUnitsByBilletsUseCase
    extends UseCase<List<Unit>, GetUnitsByBilletsParam> {}

class GetUnitsByBilletsParam {
  final String condominiumId;
  final BilletFilter filter;

  GetUnitsByBilletsParam({
    required this.condominiumId,
    required this.filter,
  });
}
