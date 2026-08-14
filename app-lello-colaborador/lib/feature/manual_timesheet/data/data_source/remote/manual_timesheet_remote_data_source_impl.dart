import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_api.dart';
import 'package:colaborador/feature/manual_timesheet/data/data_source/remote/manual_timesheet_remote_data_source.dart';
import 'package:colaborador/feature/manual_timesheet/data/model/manual_timesheet_model.dart';
import 'package:essentials/essentials.dart';

class ManualTimeSheetRemoteDataSourceImpl extends ManualTimeSheetRemoteDataSource {
  final ManualTimeSheetApi api;

  ManualTimeSheetRemoteDataSourceImpl({required this.api});

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    final response = await api.getAwsUrl(condoId);
    final aws =
        ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
    return aws;
  }

  @override
  Future<ManualTimeSheetModel> registerManualTimeSheet(
      ManualTimeSheetModel model, String condoId) async {
    final response = await api.registerManualTimeSheet(model, condoId);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return model;
    }
  }
}
