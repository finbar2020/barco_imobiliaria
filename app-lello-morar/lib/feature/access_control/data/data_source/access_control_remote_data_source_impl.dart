import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_api.dart';
import 'package:morar/feature/access_control/data/data_source/access_control_remote_data_source.dart';
import 'package:morar/feature/access_control/data/model/access_control_authorizations_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_register_facial_response_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_send_invite_model.dart';
import 'package:morar/feature/access_control/data/model/access_control_visitant_model.dart';
import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';

class AccessControlRemoteDataSourceImpl extends AccessControlRemoteDataSource {
  final AccessControlApi api;
  AccessControlRemoteDataSourceImpl({required this.api});

  @override
  Future<List<AccessControlModel>> listVisitants(String unitId) async {
    final response = await api.getVisitants(unitId);
    final visitants = ApiMapper.mapList(
        response, (json) => AccessControlModel.fromJson(json));
    return visitants;
  }

  @override
  Future<AccessControlModel> saveVisitant(
      AccessControlVisitantModel visitant) async {
    final response = await api.saveVisitant(visitant);
    final result =
        ApiMapper.map(response, (json) => AccessControlModel.fromJson(json));
    return result;
  }

  @override
  Future<String> editVisitant(AccessControlVisitantModel visitant) async {
    final response = await api.editVisitant(visitant);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<String> deleteVisitant(String gestId) async {
    final response = await api.deleteVisitant(gestId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<String> addVisit(String gestId, String unitId,
      AccessControlAuthorizationsModel model) async {
    final response = await api.saveVisit(model, gestId, unitId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<String> deleteVisit(String recurrenceId) async {
    final response = await api.deleteVisit(recurrenceId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
  }

  @override
  Future<String> editVisit(
    AccessControlAuthorizationsModel model,
    String recurrenceId,
  ) async {
    final response = await api.editVisit(model, recurrenceId);
    if (response.isSuccessful == false) {
      print(response.error);
      throw response.error!;
    } else {
      return "";
    }
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
    final model = ApiMapper.map(response,
        (json) => AccessControlRegisterFacialResponseModel.fromJson(json));
    return model;
  }

  @override
  Future<String> sendInvite(AccessControlSendInviteModel model) async {
    final response = await api.sendInvite(model);
    if (response.isSuccessful == false) {
      throw response.error!;
    } else {
      return response.body;
    }
  }
}
