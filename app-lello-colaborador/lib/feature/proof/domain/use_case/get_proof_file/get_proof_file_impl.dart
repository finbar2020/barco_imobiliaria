import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/proof/domain/repository/proof_repository.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:essentials/essentials.dart';

class GetProofFileUseCaseImpl extends GetProofFileUseCase {
  final ProofRepository repository;

  GetProofFileUseCaseImpl({required this.repository});
  @override
  Future<Try<ProofFileEntity>> call(GetProofFileParams params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.getProofFile(params.condominiumId, params.fileName);
  }

  Failure? _validate(GetProofFileParams params) {
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    //if (params.fileName == null) return InvalidParamFailure();
    return null;
  }
}
