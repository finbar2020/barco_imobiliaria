import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';

abstract class DigitalPointLocalDataSource {
  Future<List<DigitalPointModel>> select(
    String condoId,
    String meId,
    String status,
  );

  Future<List<DigitalPointModel>> selectAll(
    String condoId,
    String meId,
  );

  Future<List<DigitalPointModel>> selectPendingFromDevice();

  Future<List<DigitalPointLogData>> selectLogById(int pointId);

  Future<DigitalPointModel> save(
      DigitalPointModel model, String condoId, String meId);
  Future<bool> updatePointStatus({
    required int? id,
    required DigitalPointStatusEnum newStatusEnum,
  });

  void saveDigitalPointLog(DigitalPointModel model, String statusPrevious,
      {String description = ""});

  Future<List<DigitalPointModel>> selectNoAuthList();
}
