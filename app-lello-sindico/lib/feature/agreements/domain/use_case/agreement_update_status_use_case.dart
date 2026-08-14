import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_update_status.dart';

abstract class AgreementUpdateStatusUseCase
    extends UseCase<Agreement, AgreementUpdateStatusParams> {}

class AgreementUpdateStatusParams {
  final String condominiumId;
  final AgreementUpdateStatus updateStatus;

  AgreementUpdateStatusParams(
      {required this.condominiumId, required this.updateStatus});
}
