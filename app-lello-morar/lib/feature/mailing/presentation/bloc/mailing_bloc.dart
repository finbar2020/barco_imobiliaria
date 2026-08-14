import 'package:essentials/essentials.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_event.dart';
import 'package:morar/feature/mailing/presentation/bloc/mailing_state.dart';

class MailingBloc extends Bloc<MailingEvent, MailingState> {
  MailingBloc() : super(const MailingInitialState()) {
    on<MailingEmptyEvent>(handleMailingEmptyEvent);
    on<MailingSuccessEvent>(handleMailingSuccessEvent);
    on<MailingFailureEvent>(handleMailingFailureEvent);
    on<MailingLoadingEvent>(handleMailingLoadingEvent);
  }

  void handleMailingEmptyEvent(MailingEmptyEvent event, Emitter emit) =>
      emit(const MailingInitialState());
  void handleMailingSuccessEvent(MailingSuccessEvent event, Emitter emit) =>
      emit(MailingSuccessState(mailings: event.mailings));
  void handleMailingFailureEvent(MailingFailureEvent event, Emitter emit) =>
      emit(const MailingFailureState());
  void handleMailingLoadingEvent(MailingLoadingEvent event, Emitter emit) =>
      emit(const MailingLoadingState());
}
