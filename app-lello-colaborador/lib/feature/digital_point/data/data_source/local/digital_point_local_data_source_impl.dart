import 'package:colaborador/core/database/digital_point_database/digital_point/digital_point_dao.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_log/digital_point_log_dao.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:drift/drift.dart';

import '../../../domain/entity/digital_point_status_enum.dart';

class DigitalPointLocalDataSourceImpl extends DigitalPointLocalDataSource {
  final DigitalPointDao digitalPointDao;
  final DigitalPointLogDao digitalPointLogDao;

  DigitalPointLocalDataSourceImpl({
    required this.digitalPointDao,
    required this.digitalPointLogDao,
  });

  @override
  Future<DigitalPointModel> save(
      DigitalPointModel model, String condoId, String meId) async {
    final digitalPointTableCompanion = DigitalPointTableCompanion(
      meId: Value(meId),
      condominiumId: Value(condoId),
      date: Value(model.date),
      latitude: Value(model.latitude),
      longitude: Value(model.longitude),
      typePoint: Value(model.typePoint),
      photoTempHash: Value(model.photoTempHash),
      photoPath: Value(model.photoPath),
      status: Value(model.status),
      captureType: Value(model.typeCapture),
      uniqueHash: Value(model.uniqueHash),
      reference: Value(model.reference),
      numCra: Value(model.numCra),
      numCad: Value(model.numCad),
      tabletSession: Value(model.tabletSession ?? false),
    );

    await digitalPointDao.insert(digitalPointTableCompanion);

    DigitalPointData? response =
        await digitalPointDao.getSingle(condoId, meId, model.date);

    if (response == null) {
      return model;
    }

    return _mapDigitalPointDataToDigitalPointModel(response);
  }

  @override
  Future<List<DigitalPointModel>> select(
      String condoId, String meId, String status) async {
    final digitalPointData =
        await digitalPointDao.listByStatus(condoId, meId, status);
    if (digitalPointData.isEmpty) {
      return [];
    }

    List<DigitalPointModel> models = digitalPointData
        .map((e) => _mapDigitalPointDataToDigitalPointModel(e))
        .toList();

    return models;
  }

  @override
  Future<List<DigitalPointModel>> selectAll(
    String condoId,
    String meId,
  ) async {
    final digitalPointData = await digitalPointDao.listAll(condoId, meId);
    if (digitalPointData.isEmpty) {
      return [];
    }

    List<DigitalPointModel> models = digitalPointData
        .map((e) => _mapDigitalPointDataToDigitalPointModel(e))
        .toList();

    return models;
  }

  @override
  Future<List<DigitalPointModel>> selectPendingFromDevice() async {
    final digitalPointData = await digitalPointDao.listPendingFromDevice();
    if (digitalPointData.isEmpty) {
      return [];
    }

    List<DigitalPointModel> models = digitalPointData
        .map((e) => _mapDigitalPointDataToDigitalPointModel(e))
        .toList();

    return models;
  }

  @override
  Future<bool> updatePointStatus({
    required int? id,
    required DigitalPointStatusEnum newStatusEnum,
  }) async {
    if (id == null) {
      return false;
    }
    await digitalPointDao.updatePointStatus(
      id: id,
      newStatusEnum: newStatusEnum,
    );
    return true;
  }

  DigitalPointModel _mapDigitalPointDataToDigitalPointModel(
          DigitalPointData data) =>
      DigitalPointModel(
        id: data.id,
        date: data.date,
        latitude: data.latitude,
        longitude: data.longitude,
        typePoint: data.typePoint,
        photoTempHash: data.photoTempHash,
        photoPath: data.photoPath,
        status: data.status,
        typeCapture: data.captureType,
        uniqueHash: data.uniqueHash,
        tabletSession: data.tabletSession,
        numCad: data.numCad,
        numCra: data.numCra,
        reference: data.reference,
      );

  @override
  void saveDigitalPointLog(DigitalPointModel model, String statusPrevious,
      {String description = ""}) {
    if (model.id == null) {
      return;
    }
    final digitalPointLogTableCompanion = DigitalPointLogTableCompanion(
      digitalPointId: Value(model.id!),
      date: Value(DateTime.now()),
      statusPrevious: Value(statusPrevious),
      statusNew: Value(model.status),
      description: Value(description),
    );

    digitalPointLogDao.insert(digitalPointLogTableCompanion);
  }

  @override
  Future<List<DigitalPointLogData>> selectLogById(int pointId) async {
    return await digitalPointLogDao.list(pointId);
  }

  @override
  Future<List<DigitalPointModel>> selectNoAuthList() async {
    final digitalPointData = await digitalPointDao.listPendingFromDevice();
    if (digitalPointData.isEmpty) {
      return [];
    }

    List<DigitalPointModel> models = digitalPointData
        .map((e) => _mapDigitalPointDataToDigitalPointModel(e))
        .toList();

    return models;
  }
}
