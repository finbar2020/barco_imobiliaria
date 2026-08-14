import 'package:essentials/essentials.dart';
import 'package:lello/feature/nonpayment/data/repository/nonpayments_repository.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/domain/use_case/get_nonpayments.dart';

class GetNonPaymentsImpl extends GetNonPayments {
  final NonPaymentsRepository repository;

  GetNonPaymentsImpl({required this.repository});

  @override
  Future<Try<NonPayment>> call(GetNonPaymentsParam params) async {
    final error = validate(params);
    if (error != null) return Rejection(error);

    final result = await repository.get(params.condominiumId, params.period);
    return result;
  }

  Failure? validate(GetNonPaymentsParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    if (params.period.isEmpty) return InvalidParamFailure();
    return null;
  }
}
