import 'dart:io';

import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

abstract class ManualTimeSheetRepository {
  Future<Try<ManualTimeSheetEntity>> registerManualTimeSheet(
      ManualTimeSheetEntity entity, String condoId, String meId);

  Future<Try<UrlUploadS3>> getUrlAws(String condoId);
  Future<Try<String>> uploadImageToAws(File file, String url);
}
