import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';

abstract class QuestionCreateState {}

class QuestionCreateEmptyState extends QuestionCreateState {
  QuestionCreateEmptyState();
}

class QuestionCreateLoadingState extends QuestionCreateState {
  QuestionCreateLoadingState();
}

class QuestionCreateLoadedState extends QuestionCreateState {
  List<AccountabilityQuestionType> data;
  QuestionCreateLoadedState({required this.data});
}

class QuestionCreateFailedState extends QuestionCreateState {
  final Failure error;
  String? errorMessageKey;
  QuestionCreateFailedState({
    required this.error,
    this.errorMessageKey,
  });
}

class QuestionCreateSendingState extends QuestionCreateState {
  QuestionCreateSendingState();
}

class QuestionCreateSendedState extends QuestionCreateState {}

class QuestionCreateSendFailedState extends QuestionCreateState {
  final Failure error;
  String? errorMessageKey;
  QuestionCreateSendFailedState({
    required this.error,
    this.errorMessageKey,
  });
}
