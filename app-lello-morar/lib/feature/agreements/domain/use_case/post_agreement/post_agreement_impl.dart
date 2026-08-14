import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement.dart';

class PostAgreementImplUseCase extends PostAgreementUseCase {
  final AgreementsRepository repository;

  PostAgreementImplUseCase({required this.repository});
  @override
  Future<Try<Agreement>> call(PostAgreementParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response = await repository.postAgreement(params.condoId, params.body);
    return response;
  }

  Failure? _validate(PostAgreementParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
