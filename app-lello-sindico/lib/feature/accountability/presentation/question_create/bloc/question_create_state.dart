import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';

abstract class QuestionCreateState extends Equatable {
  const QuestionCreateState();

  @override
  List<Object?> get props => [];
}

class QuestionCreateEmptyState extends QuestionCreateState {
  const QuestionCreateEmptyState();
}

class QuestionCreateLoadingState extends QuestionCreateState {
  const QuestionCreateLoadingState();
}

class QuestionCreateLoadedState extends QuestionCreateState {
  final List<AccountabilityQuestionType> data;

  const QuestionCreateLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

class QuestionCreateFailedState extends QuestionCreateState {
  final Failure error;
  final String? errorMessageKey;

  const QuestionCreateFailedState({
    required this.error,
    this.errorMessageKey,
  });

  @override
  List<Object?> get props => [error, errorMessageKey];
}

class QuestionCreateSendingState extends QuestionCreateState {
  const QuestionCreateSendingState();
}

class QuestionCreateSendedState extends QuestionCreateState {
  const QuestionCreateSendedState();
}

class QuestionCreateSendFailedState extends QuestionCreateState {
  final Failure error;
  final String? errorMessageKey;

  const QuestionCreateSendFailedState({
    required this.error,
    this.errorMessageKey,
  });

  @override
  List<Object?> get props => [error, errorMessageKey];
}
