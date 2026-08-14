import 'package:essentials/essentials.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_api.dart';
import 'package:lello/feature/access_management/data/data_source/access_management_remote_data_source.dart';
import 'package:lello/feature/access_management/data/model/access_control_register_facial_response_model.dart';
import 'package:lello/feature/access_management/data/model/access_management_send_invite_model.dart';
import 'package:lello/feature/access_management/data/model/access_management_service_seventh_model.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';

class AccessManagementRemoteDataSourceImpl
    extends AccessManagementRemoteDataSource {
  final AccessManagementApi api;

  AccessManagementRemoteDataSourceImpl({required this.api});

  @override
  Future<AccessManagementServiceSeventhModel> checkSeventhService(
      String reference) async {
    final response = await api.checkSeventhService(reference);
    return ApiMapper.map(
        response, (json) => AccessManagementServiceSeventhModel.fromJson(json));
  }

  @override
  Future<UrlUploadS3Model> getUrlAws() async {
    final response = await api.getAwsUrl();
    final aws =
        ApiMapper.map(response, (json) => UrlUploadS3Model.fromJson(json));
    return aws;
  }

  @override
  Future<AccessControlRegisterFacialResponseModel> registerFacialBiometric(
      String hash) async {
    final response = await api.registerFacialBiometric(hash);
    final facial = ApiMapper.map(response,
        (json) => AccessControlRegisterFacialResponseModel.fromJson(json));
    return facial;
  }

  @override
  Future<String> sendInvite(AccessManagementSendInviteModel model) async {
    final response = await api.sendInvite(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return response.body;
    }
  }
}
