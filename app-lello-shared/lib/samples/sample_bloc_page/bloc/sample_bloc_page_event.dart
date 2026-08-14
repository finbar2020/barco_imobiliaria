import 'package:essentials/essentials.dart';

abstract class SampleBlocPageEvent {}

class SampleBlocPageEmptyEvent extends SampleBlocPageEvent {}

class SampleBlocPageLoadingEvent extends SampleBlocPageEvent {}

class SampleBlocPageSuccessEvent extends SampleBlocPageEvent {
  var value;
  SampleBlocPageSuccessEvent({required this.value});
}

class SampleBlocPageFailureEvent extends SampleBlocPageEvent {
  final Failure? error;
  SampleBlocPageFailureEvent({this.error});
}
