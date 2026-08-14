import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';

abstract class PostAgreementUseCase
    extends UseCase<Agreement, PostAgreementParams> {}

class PostAgreementParams {
  final String condoId;
  final AgreementCreated body;

  PostAgreementParams({
    required this.condoId,
    required this.body,
  });
}
