import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_service_seventh.dart';
import 'package:morar/feature/sub_user/data/data_source/sub_user_remote_data_source.dart';
import 'package:morar/feature/sub_user/data/data_source/subuser_api.dart';
import 'package:morar/feature/sub_user/data/model/pending_request_model.dart';
import 'package:morar/feature/sub_user/data/model/sub_user_model.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';
import 'package:morar/feature/sub_user/domain/repository/sub_user_repository.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_failures.dart';

import '../model/update_access_request_status_model.dart';

class SubUserRepositoryImpl extends SubUserRepository {
  final SubUserRemoteDataSource dataSource;

  SubUserRepositoryImpl({required this.dataSource});

  Future<Try<List<SubUser>>> getSubUsers(String unityId) async {
    try {
      final data = await dataSource.getSubUsers(unityId);
      final entity = data?.map((e) => e.toEntity()).toList() ?? [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unityId: $unityId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<SubUser>>> updateSubUser(SubUser resident) async {
    try {
      final model = SubUserModel.fromEntity(resident);
      final data = await dataSource.updateSubUser(model);
      final entity = data?.map((e) => e.toEntity()).toList() ?? [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'resident: ${resident.id}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<SubUser>>> insertSubUser(SubUser resident) async {
    try {
      final model = SubUserModel.fromEntity(resident);
      final data = await dataSource.insertSubUser(model);
      final entity = data?.map((e) => e.toEntity()).toList() ?? [];
      return Success(entity);
    } on ApiFailure catch (e) {
      return Rejection(_mapApiFailure(e));
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: ${resident.unitId}',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  Failure _mapApiFailure(ApiFailure err) {
    if (err.failure == SubUserApi.insert_sub_user_conflict_failure) {
      return InsertSubUserConflictFailure(
          err.title ?? "insert_sub_user_conflict_failure", err);
    }
    return UnknownFailure(err);
  }

  @override
  Future<Try<List<SubUserRole>>> getRoles() async {
    try {
      final data = await dataSource.getRoles();
      final entity = data?.map((e) => e.toEntity()).toList() ?? [];
      return Success(entity);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(e, stacktrace);
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<AccessControlServiceSeventh>> checkSeventhService(
      String reference) async {
    try {
      final data = await dataSource.checkSeventhService(reference);
      return Success(data.toEntity());
    } catch (e) {
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<String>> sendAccessRenewRequest(String unitId) async {
    try {
      final data = await dataSource.sendAccessRenewRequest(unitId);
      return Success(data);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<List<PendingRequestEntity>>> getPendingRequests(
      String unitId) async {
    try {
      final data = await dataSource.getPendingRequests(unitId);
      return Success(
        data.map((item) => item.toEntity()).toList(),
      );
    } catch (e, _) {
      FirebaseCrashlytics.instance.recordError(
        e,
        _,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> updateAccessRequestStatus(
    int id,
    String status,
    DateTime? expiresAt,
  ) async {
    try {
      final body = UpdateAccessRequestStatusModel(
        id: id,
        status: status,
        expiresAt: expiresAt,
      );
      final value = await dataSource.updateAccessRequestStatus(body);
      return Success(value);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'id: $id, status: $status',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<bool>> deleteSubUser(String unitId, String cpfCnpj) async {
    try {
      final data = await dataSource.deleteSubUser(unitId, cpfCnpj);
      return Success(data);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'unitId: $unitId',
      );
      return Rejection(UnknownFailure(e));
    }
  }
}
