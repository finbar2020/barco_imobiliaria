import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';

abstract class ProofRemoteDataSource {
  Future<List<ProofModel>> getProof(condominiumId, DateTime date);
  Future<ProofFileModel> getFileProof(String condominiumId, String fileName);
}
