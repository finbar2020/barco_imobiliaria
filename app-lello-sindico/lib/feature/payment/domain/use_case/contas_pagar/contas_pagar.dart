import 'package:essentials/base/use_case.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';

abstract class ContasPagar
    extends UseCase<List<ContasPagarEntity>, ContasPagarParam> {}

class ContasPagarParam {
  final String condominiumId;
  final String? dataVencimentoDe;
  final String? dataVencimentoAte;

  ContasPagarParam({
    required this.condominiumId,
    this.dataVencimentoDe,
    this.dataVencimentoAte,
  });
}
