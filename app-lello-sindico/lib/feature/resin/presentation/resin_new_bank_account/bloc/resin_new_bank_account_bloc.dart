import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_event.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_state.dart';

class ResinNewBankAccountBloc
    extends Bloc<ResinNewBankAccountEvent, ResinNewBankAccountState> {
  ResinNewBankAccountBloc() : super(ResinNewBankAccountLoadingState()) {
    on<ResinNewBankAccountLoadingEvent>(handleNewBankAccountLoadingEvent);
    on<ResinNewBankAccountLoadedEvent>(handleNewBankAccountLoadedEvent);
    on<ResinNewBankAccountErrorEvent>(handleNewBankAccountErrorEvent);
  }

  void handleNewBankAccountLoadingEvent(
          ResinNewBankAccountLoadingEvent event, Emitter emit) =>
      emit(ResinNewBankAccountLoadingState());

  void handleNewBankAccountLoadedEvent(
          ResinNewBankAccountLoadedEvent event, Emitter emit) =>
      emit(ResinNewBankAccountLoadedState(
        resinBanks: event.resinBanks,
        resinPeople: event.resinPeople,
        dialogMessageKey: event.dialogMessageKey,
        isSuccess: event.isSuccess,
        isUpdating: event.isUpdating,
        resinAccount: event.resinAccount,
      ));

  void handleNewBankAccountErrorEvent(
          ResinNewBankAccountErrorEvent event, Emitter emit) =>
      emit(ResinNewBankAccountErrorState(
        errorMessageKey: event.errorMessageKey,
      ));
}
