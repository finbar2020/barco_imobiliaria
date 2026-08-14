import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/repository/agreements_repository.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail.dart';

class GetAgreementDetailImplUseCase extends GetAgreementDetailUseCase {
  final AgreementsRepository repository;

  GetAgreementDetailImplUseCase({required this.repository});
  @override
  Future<Try<Agreement>> call(GetAgreementDetailParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);
    var response =
        await repository.getAgreementDetail(params.condoId, params.agreementId);
    return response;
  }

  Failure? _validate(GetAgreementDetailParams? params) {
    if (params == null) return InvalidParamFailure();
    return null;
  }
}
