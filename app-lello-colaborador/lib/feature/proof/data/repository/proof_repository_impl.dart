import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/proof/domain/repository/proof_repository.dart';
import 'package:essentials/essentials.dart';

class ProofRepositoryImpl extends ProofRepository {
  final ProofRemoteDataSource remoteDataSource;

  ProofRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<List<ProofEntity>>> getProof(condominiumId, DateTime date) async {
    try {
      final data = await remoteDataSource.getProof(condominiumId, date);
      data.sort((a, b) => a.nsr!.compareTo(b.nsr!));
      return Success(data.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ProofFileEntity>> getProofFile(
    String condominiumId,
    String fileName,
  ) async {
    try {
      ProofFileModel response =
          await remoteDataSource.getFileProof(condominiumId, fileName);

      return Success(response.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }
}
