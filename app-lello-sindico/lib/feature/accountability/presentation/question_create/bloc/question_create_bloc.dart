import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_event.dart';
import 'package:lello/feature/accountability/presentation/question_create/bloc/question_create_state.dart';

class QuestionCreateBloc
    extends Bloc<QuestionCreateEvent, QuestionCreateState> {
  QuestionCreateBloc() : super(QuestionCreateEmptyState()) {
    on<QuestionCreateLoadingEvent>(handleQuestionCreateLoadingEvent);
    on<QuestionCreateSendingEvent>(handleQuestionCreateSendingEvent);
    on<QuestionCreateLoadedEvent>(handleQuestionCreateLoadedEvent);
    on<QuestionCreateFailedEvent>(handleQuestionCreateFailedEvent);
    on<QuestionCreateSendFailedEvent>(handleQuestionCreateSendFailedEvent);
    on<QuestionCreateSendedEvent>(handleQuestionCreateSendedEvent);
  }

  void handleQuestionCreateLoadingEvent(
    QuestionCreateLoadingEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateLoadingState());
  }

  void handleQuestionCreateSendingEvent(
    QuestionCreateSendingEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateSendingState());
  }

  void handleQuestionCreateLoadedEvent(
    QuestionCreateLoadedEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateLoadedState(data: event.data));
  }

  void handleQuestionCreateFailedEvent(
    QuestionCreateFailedEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateFailedState(error: event.failure));
  }

  void handleQuestionCreateSendFailedEvent(
    QuestionCreateSendFailedEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateSendFailedState(error: event.failure));
  }

  void handleQuestionCreateSendedEvent(
    QuestionCreateSendedEvent event,
    Emitter emit,
  ) {
    emit(QuestionCreateSendedState());
  }
}
