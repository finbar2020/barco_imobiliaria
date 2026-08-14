import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_event.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_state.dart';

class AgreementsBloc extends Bloc<AgreementsEvent, AgreementsState> {
  AgreementsBloc() : super(AgreementsEmptyState()) {
    on<AgreementsEmptyEvent>(handleAgreementsEmptyEvent);
    on<AgreementsLoadingEvent>(handleAgreementsLoadingEvent);
    on<AgreementsErrorEvent>(handleAgreementsErrorEvent);
    on<AgreementsSuccessEvent>(handleAgreementsSuccessEvent);
    on<AgreementsApprovalPostedEvent>(handleAgreementsApprovalPostedEvent);
    on<AgreementsSendingEvent>(handleAgreementsSendingEvent);
  }

  void handleAgreementsEmptyEvent(AgreementsEmptyEvent event, Emitter emit) =>
      emit(AgreementsEmptyState());
  void handleAgreementsLoadingEvent(
          AgreementsLoadingEvent event, Emitter emit) =>
      emit(AgreementsLoadingState());
  void handleAgreementsErrorEvent(AgreementsErrorEvent event, Emitter emit) =>
      emit(AgreementsErrorState(error: event.error));
  void handleAgreementsSuccessEvent(
          AgreementsSuccessEvent event, Emitter emit) =>
      emit(AgreementsSuccessState(agreements: event.agreements));
  void handleAgreementsSendingEvent(
          AgreementsSendingEvent event, Emitter emit) =>
      emit(AgreementsSendingState());
  void handleAgreementsApprovalPostedEvent(
          AgreementsApprovalPostedEvent event, Emitter emit) =>
      emit(AgreementsApprovalPostedState(approved: event.approved));
}
