import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';

abstract class ResinMenuEvent extends Equatable {
  const ResinMenuEvent();

  @override
  List<Object?> get props => [];
}

class ResinMenuLoadingsEvent extends ResinMenuEvent {
  const ResinMenuLoadingsEvent();
}

class ResinMenuLoadedEvent extends ResinMenuEvent {
  final ResinParams params;

  const ResinMenuLoadedEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class ResinMenuErrorEvent extends ResinMenuEvent {
  final String errorMessageKey;

  const ResinMenuErrorEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
