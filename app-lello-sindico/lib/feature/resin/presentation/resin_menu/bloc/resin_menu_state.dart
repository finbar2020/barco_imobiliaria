import 'package:lello/feature/resin/domain/entity/resin_params.dart';

abstract class ResinMenuState {}

class ResinMenuLoadingState extends ResinMenuState {}

class ResinMenuErrorState extends ResinMenuState {
  String errorMessageKey;
  ResinMenuErrorState({required this.errorMessageKey});
}

class ResinMenuLoadedState extends ResinMenuState {
  ResinParams params;
  ResinMenuLoadedState({required this.params});
}
