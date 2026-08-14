import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_api.dart';
import 'package:lello/feature/staff_access_management/data/data_source/staff_access_management_data_source.dart';
import 'package:lello/feature/staff_access_management/data/model/building_manager_user_model.dart';
import 'package:lello/feature/staff_access_management/domain/entity/condo_user_manage_type.dart';
import 'package:lello/feature/staff_access_management/data/model/update_non_manager_user_model.dart';

class StaffAccessManagementRemoteDataSourceImpl
    implements StaffAccessManagementRemoteDataSource {
  final StaffAccessManagementApi api;

  StaffAccessManagementRemoteDataSourceImpl({required this.api});

  @override
  Future<ApiResponseModel> getBuildingManagerUsers(
      String? condominiumId, CondoUserManageType? condoUserManageType) async {
    final response = await api.getBuildingManagerUsers(
        condominiumId, condoUserManageType?.toFormatString());
    final result =
        ApiMapper.map(response, (json) => ApiResponseModel.fromJson(json));
    return result;
  }

  @override
  Future<ApiResponseModel> deactivateNonManagerUser(
      String condominiumId, String userId, bool isActive) async {
    final response = await api.deactivateUser(condominiumId,
        UpdateNonManagerUserModel(id: userId, isActive: isActive));

    ApiResponseModel result =
        ApiMapper.map(response, (json) => ApiResponseModel.fromJson(json));

    return result;
  }

  @override
  Future<ApiResponseModel> postNonUser(
      BuildingManagerUserModel model, String condominiumId) async {
    final response = await api.postUser(model, condominiumId);
    ApiResponseModel result =
        ApiMapper.map(response, (json) => ApiResponseModel.fromJson(json));
    return result;
  }

  @override
  Future<ApiResponseModel> putBuildingManagerUser(
      BuildingManagerUserModel model, String condominiumId) async {
    final response = await api.putUser(model, condominiumId);
    ApiResponseModel result =
        ApiMapper.map(response, (json) => ApiResponseModel.fromJson(json));
    return result;
  }
}
