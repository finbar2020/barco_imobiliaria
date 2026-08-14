import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_event.dart';
import 'package:lello/feature/accountability/presentation/question_list/bloc/question_list_state.dart';

class QuestionListBloc extends Bloc<QuestionListEvent, QuestionListState> {
  QuestionListBloc() : super(QuestionListEmptyState()) {
    on<QuestionListEmptyEvent>(handleQuestionListSetupEvent);
    on<QuestionListLoadingEvent>(handleQuestionListLoadingEvent);
    on<QuestionListLoadedEvent>(handleQuestionListLoadedEvent);
    on<QuestionListFailedEvent>(handleQuestionListFailedEvent);
  }

  void handleQuestionListSetupEvent(
      QuestionListEmptyEvent event, Emitter emit) {
    emit(QuestionListEmptyState());
  }

  void handleQuestionListLoadingEvent(
      QuestionListLoadingEvent event, Emitter emit) {
    emit(QuestionListLoadingState());
  }

  void handleQuestionListLoadedEvent(
      QuestionListLoadedEvent event, Emitter emit) {
    emit(QuestionListLoadedState(data: event.data));
  }

  void handleQuestionListFailedEvent(
      QuestionListFailedEvent event, Emitter emit) {
    emit(QuestionListFailedState(error: event.error));
  }
}
