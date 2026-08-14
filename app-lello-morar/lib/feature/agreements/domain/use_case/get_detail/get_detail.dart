import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';

abstract class GetAgreementDetailUseCase
    extends UseCase<Agreement, GetAgreementDetailParams> {}

class GetAgreementDetailParams {
  final String condoId;
  final String agreementId;

  GetAgreementDetailParams({
    required this.condoId,
    required this.agreementId,
  });
}
