import 'package:essentials/essentials.dart';

abstract class SampleBlocWidgetEvent {}

class SampleBlocWidgetEmptyEvent extends SampleBlocWidgetEvent {}

class SampleBlocWidgetLoadingEvent extends SampleBlocWidgetEvent {}

class SampleBlocWidgetSuccessEvent extends SampleBlocWidgetEvent {
  var value;
  SampleBlocWidgetSuccessEvent({required this.value});
}

class SampleBlocWidgetFailureEvent extends SampleBlocWidgetEvent {
  final Failure? error;
  SampleBlocWidgetFailureEvent({this.error});
}
