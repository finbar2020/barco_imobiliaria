import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';

abstract class ResinMenuState extends Equatable {
  const ResinMenuState();

  @override
  List<Object?> get props => [];
}

class ResinMenuLoadingState extends ResinMenuState {
  const ResinMenuLoadingState();
}

class ResinMenuErrorState extends ResinMenuState {
  final String errorMessageKey;

  const ResinMenuErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class ResinMenuLoadedState extends ResinMenuState {
  final ResinParams params;

  const ResinMenuLoadedState({required this.params});

  @override
  List<Object?> get props => [params];
}
