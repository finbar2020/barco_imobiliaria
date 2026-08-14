import 'package:lello/feature/access_management/data/model/access_control_register_facial_response_model.dart';
import 'package:lello/feature/access_management/data/model/access_management_send_invite_model.dart';
import 'package:lello/feature/access_management/data/model/access_management_service_seventh_model.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';

abstract class AccessManagementRemoteDataSource {
  Future<AccessManagementServiceSeventhModel> checkSeventhService(
      String reference);

  Future<AccessControlRegisterFacialResponseModel> registerFacialBiometric(
      String hash);
  Future<UrlUploadS3Model> getUrlAws();
  Future<String> sendInvite(AccessManagementSendInviteModel model);
}
