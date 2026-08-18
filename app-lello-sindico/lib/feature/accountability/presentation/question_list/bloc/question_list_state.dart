// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';

import 'package:essentials/essentials.dart';

abstract class QuestionListState {}

class QuestionListEmptyState extends QuestionListState {}

class QuestionListLoadingState extends QuestionListState {}

class QuestionListLoadedState extends QuestionListState {
  final List<AccountabilityDoubt> data;

  QuestionListLoadedState({
    required this.data,
  });
}

class QuestionListFailedState extends QuestionListState {
  final Failure error;
  final String? errorMessageKey;
  QuestionListFailedState({
    required this.error,
    this.errorMessageKey,
  });
}
