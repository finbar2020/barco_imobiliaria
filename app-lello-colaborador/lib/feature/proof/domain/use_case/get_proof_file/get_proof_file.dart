
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:essentials/essentials.dart';

abstract class GetProofFileUseCase
    extends UseCase<ProofFileEntity, GetProofFileParams> {}

class GetProofFileParams {
  final String condominiumId;
  final String fileName;

  GetProofFileParams({required this.condominiumId, required this.fileName});
}
