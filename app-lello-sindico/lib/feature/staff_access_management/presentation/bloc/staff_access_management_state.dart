import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

class StaffAccessManagementState {}

class EmptyStaffAccessManagementState extends StaffAccessManagementState {}

class LoadingStaffAccessManagementState extends StaffAccessManagementState {}

class FailureNonManagerUserState extends StaffAccessManagementState {
  Failure? failure;
  bool addNonUserError;
  FailureNonManagerUserState({
    required this.failure,
    this.addNonUserError = false,
  });
}

class SuccessNonManagerUserState extends StaffAccessManagementState {}

class LoadedNonManagerUserState extends StaffAccessManagementState {
  List<BuildingManagerUser> buildingManagerUsers = [];
  bool addNonUserSuccess;
  LoadedNonManagerUserState({
    required this.buildingManagerUsers,
    this.addNonUserSuccess = false,
  });
}
