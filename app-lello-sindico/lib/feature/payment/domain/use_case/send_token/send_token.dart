import 'package:essentials/base/use_case.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';

abstract class SendToken extends UseCase<SendTokenData, SendTokenParam> {}

class SendTokenParam {
  final String condominiumId;
  final SendTokenRequestEntity data;

  SendTokenParam({
    required this.condominiumId,
    required this.data,
  });
}
