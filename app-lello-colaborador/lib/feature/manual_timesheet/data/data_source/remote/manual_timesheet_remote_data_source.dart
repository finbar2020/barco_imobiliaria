import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';

abstract class ManualTimeSheetRemoteDataSource {
  Future<ManualTimeSheetModel> registerManualTimeSheet(ManualTimeSheetModel model, String condoId);
  Future<UrlUploadS3Model> getUrlAws(String condoId);
}
