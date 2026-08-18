// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';

import '../../../domain/entity/accountability_doubt.dart';

abstract class QuestionListEvent {}

class QuestionListEmptyEvent extends QuestionListEvent {}

class QuestionListLoadingEvent extends QuestionListEvent {}

class QuestionListLoadedEvent extends QuestionListEvent {
  final List<AccountabilityDoubt> data;
  QuestionListLoadedEvent({
    required this.data,
  });
}

class QuestionListFailedEvent extends QuestionListEvent {
  final Failure error;
  final String? errorMessageKey;
  QuestionListFailedEvent({
    required this.error,
    this.errorMessageKey,
  });
}
