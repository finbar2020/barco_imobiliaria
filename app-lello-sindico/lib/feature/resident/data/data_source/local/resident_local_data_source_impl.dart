import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resident/resident_dao.dart';
import 'package:lello/feature/resident/data/data_source/local/resident_local_data_source.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:drift/drift.dart';

class ResidentLocalDataSourceImpl extends ResidentLocalDataSource {
  final ResidentDao dao;
  ResidentLocalDataSourceImpl({required this.dao});

  @override
  Future<List<ResidentModel>> insert(
      String condominiumId, List<ResidentModel> data) async {
    final dataModels = data
        .map((e) => ResidentTableCompanion(
            id: Value(e.id!),
            condominiumId: Value(condominiumId),
            cpf: Value(e.cpf!),
            name: Value(e.name!),
            unitId: Value(e.unit!.id!),
            unitTitle: Value(e.unit!.title!),
            unitGroup: Value(e.unit?.group),
            unitResidentCount: Value(e.unit!.residentCount!)))
        .toList();

    await dao.insertResidents(dataModels);
    return data;
  }

  @override
  Future<List<ResidentModel>> list(String condominiumId) async {
    final list = await dao.listResidents(condominiumId);
    return list
        .map(
          (e) => ResidentModel(
            id: e.id,
            name: e.name,
            cpf: e.cpf,
            unit: (UnitModel(
              id: e.id,
              title: e.unitTitle,
              group: e.unitGroup,
              residentCount: e.unitResidentCount,
            )),
          ),
        )
        .toList();
  }

  @override
  Future<void> clear() async {
    await dao.clearResidents();
  }
}
