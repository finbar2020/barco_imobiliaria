import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';

abstract class SubUserRepository {
  Future<Try<List<SubUser>>> getSubUsers(String unityId);

  Future<Try<List<SubUser>>> updateSubUser(SubUser resident);

  Future<Try<List<SubUser>>> insertSubUser(SubUser resident);

  Future<Try<List<SubUserRole>>> getRoles();

  Future<Try<AccessControlServiceSeventh>> checkSeventhService(
      String reference);

  Future<Try<String>> sendAccessRenewRequest(String unitId);

  Future<Try<List<PendingRequestEntity>>> getPendingRequests(String unitId);

  Future<Try<bool>> updateAccessRequestStatus(
    int id,
    String status,
    DateTime? expiresAt,
  );

  Future<Try<bool>> deleteSubUser(String unitId, String cpfCnpj);
}
