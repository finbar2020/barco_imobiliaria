import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:essentials/essentials.dart';

abstract class GetProofUseCase
    extends UseCase<List<ProofEntity>, GetProofParams> {}

class GetProofParams {
  final String condominiumId;
  final DateTime date;

  GetProofParams({required this.condominiumId, required this.date});
}
