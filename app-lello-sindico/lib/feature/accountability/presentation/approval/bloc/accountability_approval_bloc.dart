import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/accountability/presentation/approval/bloc/accountability_approval_event.dart';
import 'package:lello/feature/accountability/presentation/approval/bloc/accountability_approval_state.dart';

class AccountabilityApprovalBloc
    extends Bloc<AccountabilityApprovalEvent, AccountabilityApprovalState> {
  AccountabilityApprovalBloc()
      : super(const AccountabilityApprovalInitialState()) {
    on<AccountabilityApprovalSetupEvent>(
        handleAccountabilityApprovalSetupEvent);
    on<AccountabilityApprovalInitialEvent>(
        handleAccountabilityApprovalInitialEvent);
    on<AccountabilityApprovalLoadingEvent>(
        handleAccountabilityApprovalLoadingEvent);
    on<AccountabilityApprovalFailedEvent>(
        handleAccountabilityApprovalFailedEvent);
    on<AccountabilityApprovalApprovedEvent>(
        handleAccountabilityApprovalApprovedEvent);
  }

  void handleAccountabilityApprovalApproveEvent(
      AccountabilityApprovalApprovedEvent event, Emitter emit) {
    emit(
      AccountabilityApprovalApprovedState(approval: event.approval),
    );
  }

  void handleAccountabilityApprovalSetupEvent(
      AccountabilityApprovalSetupEvent event, Emitter emit) {
    emit(AccountabilityApprovalSetupState());
  }

  void handleAccountabilityApprovalInitialEvent(
      AccountabilityApprovalInitialEvent event, Emitter emit) {
    emit(const AccountabilityApprovalInitialState());
  }

  void handleAccountabilityApprovalLoadingEvent(
      AccountabilityApprovalLoadingEvent event, Emitter emit) {
    emit(AccountabilityApprovalLoadingState());
  }

  void handleAccountabilityApprovalFailedEvent(
      AccountabilityApprovalFailedEvent event, Emitter emit) {
    emit(AccountabilityApprovalFailedState(error: event.error));
  }

  void handleAccountabilityApprovalApprovedEvent(
      AccountabilityApprovalApprovedEvent event, Emitter emit) {
    emit(AccountabilityApprovalApprovedState(approval: event.approval));
  }
}
