import 'package:essentials/essentials.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';

abstract class QuestionListState extends Equatable {
  const QuestionListState();

  @override
  List<Object?> get props => [];
}

class QuestionListEmptyState extends QuestionListState {
  const QuestionListEmptyState();
}

class QuestionListLoadingState extends QuestionListState {
  const QuestionListLoadingState();
}

class QuestionListLoadedState extends QuestionListState {
  final List<AccountabilityDoubt> data;

  const QuestionListLoadedState({required this.data});

  @override
  List<Object?> get props => [data];
}

class QuestionListFailedState extends QuestionListState {
  final Failure error;
  final String? errorMessageKey;

  const QuestionListFailedState({
    required this.error,
    this.errorMessageKey,
  });

  @override
  List<Object?> get props => [error, errorMessageKey];
}
