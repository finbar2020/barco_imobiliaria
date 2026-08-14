import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_api.dart';
import 'package:colaborador/feature/digital_point/data/data_source/remote/digital_point_remote_data_source.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:essentials/essentials.dart';

class DigitalPointRemoteDataSourceImpl extends DigitalPointRemoteDataSource {
  final DigitalPointApi api;

  DigitalPointRemoteDataSourceImpl({required this.api});

  @override
  Future<DigitalPointModel> registerPoint(
      DigitalPointModel model, String condoId) async {
    final response = await api.registerPoint(model, condoId);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      model =
          model.copyWith(status: enumToString(DigitalPointStatusEnum.sended));
      return model;
    }
  }

  @override
  Future<bool> requestDigitalPointService(
      String condoId, String imageHash) async {
    final response = await api.requestDigitalPointService(condoId, imageHash);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return true;
    }
  }

  @override
  Future<UrlUploadS3Model> getUrlAws(String condoId) async {
    final response = await api.getAwsUrl(condoId).timeout(Duration(seconds: 3));
    final aws =
        ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
    return aws;
  }

  @override
  Future<bool> checkDigitalPoint(String condoId, DateTime date) async {
    final response = await api.checkDigitalPoint(condoId, date);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return response.body;
    }
  }

  @override
  Future<void> syncPointWithouLogin(DigitalPointModel model) async {
    final response = await api.syncDigitalPointWithoutLogin(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return response.body;
    }
  }
}
