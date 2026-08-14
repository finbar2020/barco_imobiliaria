abstract class AccessManagementEvent {}

class AccessManagementErrorEvent extends AccessManagementEvent {}

class AccessManagementEmptyEvent extends AccessManagementEvent {}

class AccessManagementLoadingEvent extends AccessManagementEvent {}

class AccessManagementServiceOnEvent extends AccessManagementEvent {}

class AccessManagementServiceOffEvent extends AccessManagementEvent {}

class AccessManagementFacialFailedEvent extends AccessManagementEvent {
  String? message;
  String? code;
  AccessManagementFacialFailedEvent({
    this.message,
    this.code,
  });
}

class AccessManagementFacialSuccessEvent extends AccessManagementEvent {}
