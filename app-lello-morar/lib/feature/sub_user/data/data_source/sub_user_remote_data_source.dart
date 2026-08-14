import 'package:morar/feature/access_control/data/model/access_control_service_seventh_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_role_model.dart';
import 'package:morar/feature/sub_user/data/model/update_access_request_status_model.dart';

import '../model/pending_request_model.dart';

abstract class SubUserRemoteDataSource {
  Future<List<SubUserModel>?> getSubUsers(String unityId);

  Future<List<SubUserModel>?> updateSubUser(SubUserModel resident);

  Future<List<SubUserModel>?> insertSubUser(SubUserModel resident);

  Future<List<SubUserRoleModel>?> getRoles();

  Future<AccessControlServiceSeventhModel> checkSeventhService(
      String reference);

  Future<String> sendAccessRenewRequest(String unitId);

  Future<List<PendingRequestModel>> getPendingRequests(String unitId);

  Future<bool> updateAccessRequestStatus(
    UpdateAccessRequestStatusModel body,
  );

  Future<bool> deleteSubUser(
    String unitId,
    String cpfCnpj,
  );
}
