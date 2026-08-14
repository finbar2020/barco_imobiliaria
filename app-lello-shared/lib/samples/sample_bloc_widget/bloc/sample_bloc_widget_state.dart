import 'package:essentials/essentials.dart';

abstract class SampleBlocWidgetState {}

class SampleBlocWidgetEmptyState extends SampleBlocWidgetState {}

class SampleBlocWidgetLoadingState extends SampleBlocWidgetState {}

class SampleBlocWidgetSuccessState extends SampleBlocWidgetState {
  var value;
  SampleBlocWidgetSuccessState({required this.value});
}

class SampleBlocWidgetFailureState extends SampleBlocWidgetState {
  final Failure? error;
  SampleBlocWidgetFailureState({this.error});
}
