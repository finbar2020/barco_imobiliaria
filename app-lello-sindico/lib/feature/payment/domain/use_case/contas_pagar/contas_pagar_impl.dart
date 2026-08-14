import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar.dart';

class ContasPagarImpl extends ContasPagar {
  final PaymentRepository repository;

  ContasPagarImpl({required this.repository});

  @override
  Future<Try<List<ContasPagarEntity>>> call(ContasPagarParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.listContasPagar(
      params.condominiumId,
      params.dataVencimentoDe,
      params.dataVencimentoAte,
    );
  }

  Failure? _validate(ContasPagarParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
