import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/data/model/access_control_service_seventh_model.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source.dart';
import 'package:morar/feature/sub_user/data/data_source/subuser_api.dart';
import 'package:morar/feature/sub_user/data/model/pending_request_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_role_model.dart';

import '../model/update_access_request_status_model.dart';

class SubUserRemoteDataSourceImpl extends SubUserRemoteDataSource {
  final SubUserApi api;

  SubUserRemoteDataSourceImpl({required this.api});

  @override
  Future<List<SubUserModel>?> getSubUsers(String unityId) async {
    final response = await api.fetchSubUser(unityId);
    return ApiMapper.mapList(response, (json) => SubUserModel.fromJson(json));
  }

  @override
  Future<List<SubUserModel>?> updateSubUser(SubUserModel resident) async {
    final response = await api.upateSubUser(resident);
    return ApiMapper.mapList(response, (json) => SubUserModel.fromJson(json));
  }

  @override
  Future<List<SubUserModel>?> insertSubUser(SubUserModel resident) async {
    final response = await api.insertSubUser(resident);
    return ApiMapper.mapList(response, (json) => SubUserModel.fromJson(json));
  }

  @override
  Future<List<SubUserRoleModel>?> getRoles() async {
    final response = await api.fetchSubUserRoles();
    return ApiMapper.mapList(
        response, (json) => SubUserRoleModel.fromJson(json));
  }

  @override
  Future<AccessControlServiceSeventhModel> checkSeventhService(
      String reference) async {
    final response = await api.checkSeventhService(reference);
    return ApiMapper.map(
        response, (json) => AccessControlServiceSeventhModel.fromJson(json));
  }

  @override
  Future<String> sendAccessRenewRequest(String unitId) async {
    final response = await api.sendAccessRenewRequest(unitId);
    return response.body;
  }

  @override
  Future<List<PendingRequestModel>> getPendingRequests(String unitId) async {
    final response =
        await api.getPendingRequests(unitId, 'PENDENTE_PROPRIETARIO');
    return ApiMapper.mapList(
      response,
      (json) => PendingRequestModel.fromJson(json),
    );
  }

  @override
  Future<bool> updateAccessRequestStatus(
      UpdateAccessRequestStatusModel body) async {
    final response = await api.updateAccessRequestStatus(body);
    if (response.isSuccessful) return true;
    throw response.error ?? "";
  }

  @override
  Future<bool> deleteSubUser(String unitId, String cpfCnpj) async {
    final response = await api.deleteSubUser(unitId, cpfCnpj);
    return response.body;
  }
}
