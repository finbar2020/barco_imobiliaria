import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_question_type_solicitation.dart';

abstract class QuestionCreateEvent {}

class QuestionCreateLoadingEvent extends QuestionCreateEvent {}

class QuestionCreateSendingEvent extends QuestionCreateEvent {}

class QuestionCreateLoadedEvent extends QuestionCreateEvent {
  List<AccountabilityQuestionType> data;
  QuestionCreateLoadedEvent({
    required this.data,
  });
}

class QuestionCreateFailedEvent extends QuestionCreateEvent {
  final Failure failure;
  QuestionCreateFailedEvent({
    required this.failure,
  });
}

class QuestionCreateSendFailedEvent extends QuestionCreateEvent {
  final Failure failure;
  QuestionCreateSendFailedEvent({
    required this.failure,
  });
}

class QuestionCreateSendedEvent extends QuestionCreateEvent {}

enum FilesType { files, images }
