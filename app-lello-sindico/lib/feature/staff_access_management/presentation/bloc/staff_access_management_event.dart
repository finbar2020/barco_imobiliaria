import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';

class StaffAccessManagementEvent {}

class EmptyStaffAccessManagementEvent extends StaffAccessManagementEvent {}

class LoadingStaffAccessManagementEvent extends StaffAccessManagementEvent {}

class FailureNonManagerUserEvent extends StaffAccessManagementEvent {
  Failure? failure;
  bool addNonUserError;
  FailureNonManagerUserEvent({
    required this.failure,
    this.addNonUserError = false,
  });
}

class SuccessNonManagerUserEvent extends StaffAccessManagementEvent {}

class LoadedNonManagerUserEvent extends StaffAccessManagementEvent {
  List<BuildingManagerUser> buildingManagerUsers = [];
  bool addNonUserSuccess;
  LoadedNonManagerUserEvent({
    required this.buildingManagerUsers,
    this.addNonUserSuccess = false,
  });
}
