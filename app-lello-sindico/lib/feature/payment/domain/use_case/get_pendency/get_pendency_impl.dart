import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/use_case/list_pendency/list_pendency_failure.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_pendency/get_pendency.dart';

class GetPendencyImpl extends GetPendency {
  final PaymentRepository repository;

  GetPendencyImpl({required this.repository});

  @override
  Future<Try<Payment?>> call(GetPendencyParam params) async {
    var error = validate(params);
    if (error != null) return Rejection(error);
    var result =
        await repository.select(params.condominiumId, params.pendencyId);
    return result;
  }

  Failure? validate(GetPendencyParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty)
      return InvalidListPendencyCondominiumFailure();
    return null;
  }
}
