import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_register_facial_response_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_send_invite_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_visitant_model.dart';
import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';

abstract class AccessControlRemoteDataSource {
  Future<List<AccessControlModel>> listVisitants(String unitId);
  Future<AccessControlModel> saveVisitant(AccessControlVisitantModel visitant);
  Future<String> editVisitant(AccessControlVisitantModel visitant);
  Future<String> deleteVisitant(String gestId);
  Future<String> addVisit(
    String gestId,
    String unitId,
    AccessControlAuthorizationsModel model,
  );
  Future<String> deleteVisit(String recurrenceId);
  Future<String> editVisit(
    AccessControlAuthorizationsModel model,
    String recurrenceId,
  );

  Future<AccessControlRegisterFacialResponseModel> registerFacialBiometric(
      String hash);
  Future<UrlUploadS3Model> getUrlAws();
  Future<String> sendInvite(AccessControlSendInviteModel model);
}
