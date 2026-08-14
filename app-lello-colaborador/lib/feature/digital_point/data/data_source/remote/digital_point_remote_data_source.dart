import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/data/model/url_upload_s3_model.dart';

abstract class DigitalPointRemoteDataSource {
  Future<DigitalPointModel> registerPoint(
      DigitalPointModel model, String condoId);
  Future<bool> requestDigitalPointService(String condoId, String imageHash);
  Future<UrlUploadS3Model> getUrlAws(String condoId);
  Future<bool> checkDigitalPoint(String condoId, DateTime date);

  Future<void> syncPointWithouLogin(DigitalPointModel model);
}
