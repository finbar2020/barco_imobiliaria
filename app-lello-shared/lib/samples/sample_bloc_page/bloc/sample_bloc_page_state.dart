import 'package:essentials/essentials.dart';

abstract class SampleBlocPageState {}

class SampleBlocPageEmptyState extends SampleBlocPageState {}

class SampleBlocPageLoadingState extends SampleBlocPageState {}

class SampleBlocPageSuccessState extends SampleBlocPageState {
  var value;
  SampleBlocPageSuccessState({required this.value});
}

class SampleBlocPageFailureState extends SampleBlocPageState {
  final Failure? error;
  SampleBlocPageFailureState({this.error});
}
