import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';

abstract class GetPendency extends UseCase<Payment?, GetPendencyParam> {}

class GetPendencyParam {
  final String condominiumId;
  final String pendencyId;

  GetPendencyParam(this.condominiumId, this.pendencyId);
}
