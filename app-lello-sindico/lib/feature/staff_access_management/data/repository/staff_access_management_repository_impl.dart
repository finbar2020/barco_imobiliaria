import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_data_source.dart';
import 'package:lello/feature/staff_access_management/data/model/building_manager_user_model.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/domain/repository/staff_access_management_repository.dart';

class StaffAccessManagementRepositoryImpl
    extends StaffAccessManagementRepository {
  final StaffAccessManagementRemoteDataSource remoteDataSource;

  StaffAccessManagementRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Try<List<BuildingManagerUser>>> getBuildingManagerUsers(
      String? condominiumId, CondoUserManageType? condoUserManageType) async {
    try {
      final result = await remoteDataSource.getBuildingManagerUsers(
          condominiumId, condoUserManageType);
      List<BuildingManagerUser> users = List.from(
        result.data
            .map((e) => BuildingManagerUserModel.fromJson(e).toEntity())
            .toList(),
      );

      return Success(users);
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ApiResponse>> deactivateNonManagerUsers(
      String condominiumId, String userId, bool isActive) async {
    try {
      final result = await remoteDataSource.deactivateNonManagerUser(
          condominiumId, userId, isActive);

      ApiResponse response = result.toEntity();
      if (response.success) {
        return Success(response);
      } else {
        return Rejection(
          KnownFailure(
            response.errorCode ?? "",
            response.message,
            message: response.message,
          ),
        );
      }
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ApiResponse>> postNonUser(
      BuildingManagerUser nonUser, String condominiumId) async {
    try {
      BuildingManagerUserModel model =
          BuildingManagerUserModel.fromEntity(nonUser)!;
      ApiResponseModel result =
          await remoteDataSource.postNonUser(model, condominiumId);
      ApiResponse response = result.toEntity();
      if (response.success) {
        return Success(response);
      } else {
        return Rejection(KnownFailure(
            response.errorCode ?? "", response.message,
            message: response.message));
      }
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(UnknownFailure(e));
    }
  }

  @override
  Future<Try<ApiResponse>> putBuildingManagerUser(
      BuildingManagerUser buildingManagerUser, String condominiumId) async {
    try {
      BuildingManagerUserModel model =
          BuildingManagerUserModel.fromEntity(buildingManagerUser)!;
      ApiResponseModel result =
          await remoteDataSource.putBuildingManagerUser(model, condominiumId);
      ApiResponse response = result.toEntity();
      if (response.success) {
        return Success(response);
      } else {
        return Rejection(
          KnownFailure(response.errorCode ?? "", response.message,
              message: response.message),
        );
      }
    } catch (e, stacktrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stacktrace,
        reason: 'type: read',
      );
      return Rejection(
        UnknownFailure(e),
      );
    }
  }
}
