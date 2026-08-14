import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/unit/unit_dao.dart';
import 'package:lello/feature/unit/data/data_source/local/unit_local_data_source.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';
import 'package:drift/drift.dart';

class UnitLocalDataSourceImpl extends UnitLocalDataSource {
  final UnitDao dao;
  UnitLocalDataSourceImpl({required this.dao});

  @override
  Future<List<UnitModel>> insert(
      String condominiumId, List<UnitModel> data) async {
    final dataModels = data
        .map((e) => UnitTableCompanion(
              id: Value(e.id!),
              title: Value(e.title!),
              condominiumId: Value(e.condominiumId!),
              group: Value(e.group!),
              residentCount: Value(e.residentCount!),
              vehicleCount: Value(e.vehicleCount!),
              adimplente: Value(e.adimplente!),
              agreement: Value(e.agreement!),
              billingStatus: Value(e.billingStatus!),
              usesApp: Value(e.usesApp!),
              fixedPhone: Value(e.fixedPhone!),
              mobilePhone: Value(e.mobilePhone!),
              lastUpdated: Value(DateTime.now()),
            ))
        .toList();

    await dao.insertUnits(dataModels);
    return data;
  }

  @override
  Future<List<UnitModel>> list(String condominiumId) async {
    final list = await dao.listUnits(condominiumId);
    if (list.any((element) => double.tryParse(element.title) == null)) {
      //has text on title, order alfabetcaly
      list.sort((a, b) => a.title.compareTo(b.title));
    } else {
      //order ordinarly
      list.sort(
          (a, b) => double.parse(a.title).compareTo(double.parse(b.title)));
    }
    return list
        .map((e) => UnitModel(
              id: e.id,
              title: e.title,
              condominiumId: e.condominiumId,
              group: e.group,
              residentCount: e.residentCount,
              vehicleCount: e.vehicleCount,
              adimplente: e.adimplente,
              agreement: e.agreement,
              billingStatus: e.billingStatus,
              usesApp: e.usesApp,
              fixedPhone: e.fixedPhone,
              mobilePhone: e.mobilePhone,
              lastUpdated: e.lastUpdated,
            ))
        .toList();
  }

  @override
  Future<void> clear() async {
    await dao.clearUnits();
  }
}
