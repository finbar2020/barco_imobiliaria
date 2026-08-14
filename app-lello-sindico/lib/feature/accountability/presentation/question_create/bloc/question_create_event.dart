import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_question_type_solicitation.dart';

abstract class QuestionCreateEvent extends Equatable {
  const QuestionCreateEvent();

  @override
  List<Object?> get props => [];
}

class QuestionCreateLoadingEvent extends QuestionCreateEvent {
  const QuestionCreateLoadingEvent();
}

class QuestionCreateSendingEvent extends QuestionCreateEvent {
  const QuestionCreateSendingEvent();
}

class QuestionCreateLoadedEvent extends QuestionCreateEvent {
  final List<AccountabilityQuestionType> data;

  const QuestionCreateLoadedEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class QuestionCreateFailedEvent extends QuestionCreateEvent {
  final Failure failure;

  const QuestionCreateFailedEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class QuestionCreateSendFailedEvent extends QuestionCreateEvent {
  final Failure failure;

  const QuestionCreateSendFailedEvent({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class QuestionCreateSendedEvent extends QuestionCreateEvent {
  const QuestionCreateSendedEvent();
}

enum FilesType { files, images }
