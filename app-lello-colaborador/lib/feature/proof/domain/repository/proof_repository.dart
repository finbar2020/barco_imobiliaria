import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:essentials/essentials.dart';

abstract class ProofRepository {
  Future<Try<List<ProofEntity>>> getProof(condominiumId, DateTime date);
  Future<Try<ProofFileEntity>> getProofFile(
      String condominiumId, String fileName);
}
