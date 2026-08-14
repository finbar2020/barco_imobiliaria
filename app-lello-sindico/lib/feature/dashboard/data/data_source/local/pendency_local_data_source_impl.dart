import 'package:drift/drift.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/pendency/pendency_dao.dart';
import 'package:lello/feature/dashboard/data/data_source/local/pendency_local_data_source.dart';
import 'package:lello/feature/dashboard/data/model/pendency_model.dart';

class PendencyLocalDataSourceImpl extends PendencyLocalDataSource {
  final PendencyDao dao;
  PendencyLocalDataSourceImpl({required this.dao});

  @override
  Future<List<PendencyModel>> list(String condominiumId) async {
    final dataModels = await dao.listPendencies(condominiumId);
    return dataModels.map(fromDataModel).toList();
  }

  @override
  Future<List<PendencyModel>> save(
      String condominiumId, List<PendencyModel> pendencies) async {
    await dao.deletePendencies(condominiumId);

    final dataModels = pendencies
        .map((e) => PendencyTableCompanion(
              condominiumId: Value(condominiumId),
              id: Value(e.id!),
              type: Value(e.type!),
              // senderId: Value(e.sender!.id!),
              title: Value(e.title),
              message: Value(e.message),
              date: Value(e.date),
              // senderName: Value(e.sender?.name),
              //senderPicture: Value(e.sender?.picture),
              //module: Value(e.module)
            ))
        .toList();
    await dao.insertPendencies(dataModels);
    return pendencies;
  }

  @override
  Future<void> clear(String? condominiumId) async {
    if (condominiumId == null) {
      await dao.clearPendencies();
    } else {
      await dao.deletePendencies(condominiumId);
    }
  }

  PendencyModel fromDataModel(PendencyData e) {
    return PendencyModel()
      ..id = e.id
      ..title = e.title
      ..message = e.message
      ..date = e.date
      ..type = e.type;
    //..sender = sender
    //..module = e.module;
  }
}
