import 'dart:io';

import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class DigitalPointRepository {
  Future<Try<bool>> requestDigitalPoint(String condoId, String imageHash);

  Future<Try<DigitalPointEntity>> registerPoint(
      DigitalPointEntity entity, String condoId, String meId);

  Future<Try<DigitalPointEntity>> savePoint(
      DigitalPointEntity entity, String condoId, String meId);

  Future<Try<DigitalPointEntity>> savePointLog(
      DigitalPointEntity entity, String statusPrevious, String description);

  Future<Try<List<DigitalPointEntity>>> getPointsByStatus(
      String condoId, String meId, String status);

  Future<Try<List<DigitalPointEntity>>> getPoints(
    String condoId,
    String meId,
  );
  Future<Try<List<DigitalPointLogData>>> getPointLogs(int pointId);

  Future<Try<List<DigitalPointEntity>>> syncPoints(
      String condoId, String meId, List<DigitalPointEntity> points);

  Future<Try<UrlUploadS3>> getUrlAws(String condoId);

  Future<Try<String>> uploadImageToAws(File file, String url);

  Future<Try<bool>> checkDigitalPoint(String condoId, DateTime date);

  Future<Try<List<DigitalPointEntity>>> getPendingPoints();

  Future<Try<void>> syncPointWithoutLogin({
    required DigitalPointEntity point,
  });
}
