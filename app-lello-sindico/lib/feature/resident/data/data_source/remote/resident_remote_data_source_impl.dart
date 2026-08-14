import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_api.dart';
import 'package:lello/feature/resident/data/data_source/remote/resident_remote_data_source.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';

class ResidentRemoteDataSourceImpl extends ResidentRemoteDataSource {
  final ResidentApi api;
  ResidentRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ResidentModel>> list(String condominiumId,
      {String? query, String? lastResidentId, bool loadAll = false}) async {
    final response = await api.list(condominiumId,
        query: query, lastResidentId: lastResidentId, loadAll: loadAll);
    final residents =
        ApiMapper.mapList(response, (json) => ResidentModel.fromJson(json));

    return residents
        .map(
          (e) => e.copyWith(
            cpf: e.cpf?.formatCpfCnpj(),
          ),
        )
        .toList();
  }

  @override
  Future<List<ResidentModel>> listFromUnit(
      String condominiumId, String unitId) async {
    final response = await api.listFromUnit(condominiumId, unitId);
    final residents =
        ApiMapper.mapList(response, (json) => ResidentModel.fromJson(json));

    return residents
        .map(
          (e) => e.copyWith(
            cpf: e.cpf?.formatCpfCnpj(),
          ),
        )
        .toList();
  }
}
