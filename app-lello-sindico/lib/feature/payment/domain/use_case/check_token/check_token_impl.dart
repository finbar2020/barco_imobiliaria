import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token.dart';

class CheckTokenImpl extends CheckToken {
  final PaymentRepository repository;

  CheckTokenImpl({required this.repository});

  @override
  Future<Try<bool>> call(CheckTokenParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.checkToken(
        params.condominiumId, params.tokenId, params.value);
  }

  Failure? _validate(CheckTokenParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.tokenId <= 0) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
