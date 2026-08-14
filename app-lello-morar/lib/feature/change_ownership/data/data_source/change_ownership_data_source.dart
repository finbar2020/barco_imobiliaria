import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';
import 'package:morar/feature/change_ownership/data/model/can_change_model.dart';
import 'package:morar/feature/change_ownership/data/model/change_ownership_model.dart';

abstract class ChangeOwnershipRemoteDataSource {
  Future<UrlUploadS3Model> getAws(String condoId);
  Future<String> postChange(String condoId, ChangeOwnershipModel model);
  Future<CanChangeModel> getCanChange(String condoId);
}
