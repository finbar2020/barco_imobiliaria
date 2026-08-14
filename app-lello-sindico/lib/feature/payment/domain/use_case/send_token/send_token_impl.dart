import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token.dart';

class SendTokenImpl extends SendToken {
  final PaymentRepository repository;

  SendTokenImpl({required this.repository});

  @override
  Future<Try<SendTokenData>> call(SendTokenParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    return repository.sendToken(
      params.condominiumId,
      params.data,
    );
  }

  Failure? _validate(SendTokenParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
