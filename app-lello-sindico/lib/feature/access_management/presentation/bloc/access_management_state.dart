abstract class AccessManagementState {}

class AccessManagementEmptyState extends AccessManagementState {}

class AccessManagementLoadingState extends AccessManagementState {}

class AccessManagementErrorState extends AccessManagementState {}

class AccessManagementServiceOnState extends AccessManagementState {}

class AccessManagementServiceOffState extends AccessManagementState {}

class AccessManagementFacialFailedState extends AccessManagementState {
  String? message;
  String? code;
  AccessManagementFacialFailedState({
    this.message,
    this.code,
  });
}

class AccessManagementFacialSuccessState extends AccessManagementState {}
