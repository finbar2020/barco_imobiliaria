import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/space/space_dao.dart';
import 'package:lello/feature/space/data/data_source/local/space_local_data_source.dart';
import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:drift/drift.dart';

class SpaceLocalDataSourceImpl extends SpaceLocalDataSource {
  final SpaceDao dao;

  SpaceLocalDataSourceImpl({required this.dao});

  @override
  Future<List<SpaceModel>> insert(
      String condominiumId, List<SpaceModel> data) async {
    final dataModels = data
        .map((e) => SpaceTableCompanion(
            id: Value(e.id!),
            condominiumId: Value(condominiumId),
            name: Value(e.name),
            pictureUrl: Value(e.pictureUrl)))
        .toList();

    await dao.insert(dataModels);
    return data;
  }

  @override
  Future<List<SpaceModel>> list(String condominiumId) async {
    final list = await dao.list(condominiumId);
    return list
        .map((e) => SpaceModel()
          ..id = e.id
          ..name = e.name!
          ..pictureUrl = e.pictureUrl!)
        .toList();
  }
}
