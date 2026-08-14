import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/repository/proof_repository.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:essentials/essentials.dart';

class GetProofUseCaseImpl extends GetProofUseCase {
  final ProofRepository repository;

  GetProofUseCaseImpl({required this.repository});
  @override
  Future<Try<List<ProofEntity>>> call(GetProofParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getProof(params.condominiumId, params.date);
  }

  Failure? _validate(GetProofParams params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    //if (params.date == null) return InvalidParamFailure();
    return null;
  }
}
