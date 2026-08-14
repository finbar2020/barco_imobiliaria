import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_doubt.dart';

abstract class QuestionListEvent extends Equatable {
  const QuestionListEvent();

  @override
  List<Object?> get props => [];
}

class QuestionListEmptyEvent extends QuestionListEvent {
  const QuestionListEmptyEvent();
}

class QuestionListLoadingEvent extends QuestionListEvent {
  const QuestionListLoadingEvent();
}

class QuestionListLoadedEvent extends QuestionListEvent {
  final List<AccountabilityDoubt> data;

  const QuestionListLoadedEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class QuestionListFailedEvent extends QuestionListEvent {
  final Failure error;
  final String? errorMessageKey;

  const QuestionListFailedEvent({
    required this.error,
    this.errorMessageKey,
  });

  @override
  List<Object?> get props => [error, errorMessageKey];
}
