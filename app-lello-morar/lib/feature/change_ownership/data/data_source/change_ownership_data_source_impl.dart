import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_api.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source.dart';
import 'package:morar/feature/change_ownership/data/model/can_change_model.dart';
import 'package:morar/feature/change_ownership/data/model/change_ownership_model.dart';

class ChangeOwnershipRemoteDataSourceImpl
    implements ChangeOwnershipRemoteDataSource {
  final ChangeOwnershipApi api;

  ChangeOwnershipRemoteDataSourceImpl({required this.api});
  @override
  Future<UrlUploadS3Model> getAws(String reference) async {
    final response = await api.getAwsPayload(reference);
    return ApiMapper.map(
        response,
        (json) =>
            UrlUploadS3Model(fileName: json["file_name"], url: json["url"]));
  }

  @override
  Future<String> postChange(
      String reference, ChangeOwnershipModel model) async {
    final response = await api.postChange(reference, model);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<CanChangeModel> getCanChange(String condoId) async {
    final response = await api.getCanChange(condoId);
    return ApiMapper.map(response, (json) => CanChangeModel.fromJson(json));
  }
}
