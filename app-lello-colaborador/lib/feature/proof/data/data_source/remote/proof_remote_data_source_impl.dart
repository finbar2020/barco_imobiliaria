import 'package:colaborador/feature/proof/data/data_source/remote/proof_api.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';
import 'package:essentials/essentials.dart';

class ProofRemoteDataSourceImpl implements ProofRemoteDataSource {
  final ProofApi api;

  ProofRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ProofModel>> getProof(condominiumId, DateTime date) async {
    final response = await api.getProof(condominiumId, date);
    return ApiMapper.mapList(response, (json) => ProofModel.fromJson(json));
  }

  @override
  Future<ProofFileModel> getFileProof(
      String condominiumId, String fileName) async {
    final response = await api.getFileProof(
      condominiumId,
      fileName,
    );
    final proofFileModel =
        ApiMapper.map(response, (json) => ProofFileModel.fromJson(json));
    return proofFileModel;
  }
}
