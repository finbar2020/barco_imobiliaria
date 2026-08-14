import 'package:essentials/essentials.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_event.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';

class StaffAccessManagementBloc extends Bloc {
  StaffAccessManagementBloc() : super(EmptyStaffAccessManagementState()) {
    on<EmptyStaffAccessManagementEvent>(handleEmptyStaffAccessManagementEvent);
    on<LoadingStaffAccessManagementEvent>(
        handleLoadingStaffAccessManagementEvent);
    on<FailureNonManagerUserEvent>(handleFailureNonManagerUserEvent);
    on<LoadedNonManagerUserEvent>(handleLoadedNonManagerUserEvent);
    on<SuccessNonManagerUserEvent>(handleSuccessNonManagerUserEvent);
  }

  void handleEmptyStaffAccessManagementEvent(
      EmptyStaffAccessManagementEvent event, Emitter emit) {
    emit(
      EmptyStaffAccessManagementState(),
    );
  }

  void handleLoadingStaffAccessManagementEvent(
      LoadingStaffAccessManagementEvent event, Emitter emit) {
    emit(
      LoadingStaffAccessManagementState(),
    );
  }

  void handleFailureNonManagerUserEvent(
      FailureNonManagerUserEvent event, Emitter emit) {
    emit(
      FailureNonManagerUserState(
        failure: event.failure,
        addNonUserError: event.addNonUserError,
      ),
    );
  }

  void handleLoadedNonManagerUserEvent(
      LoadedNonManagerUserEvent event, Emitter emit) {
    emit(
      LoadedNonManagerUserState(
          buildingManagerUsers: event.buildingManagerUsers,
          addNonUserSuccess: event.addNonUserSuccess),
    );
  }

  void handleSuccessNonManagerUserEvent(
      SuccessNonManagerUserEvent event, Emitter emit) {
    emit(
      SuccessNonManagerUserState(),
    );
  }
}
