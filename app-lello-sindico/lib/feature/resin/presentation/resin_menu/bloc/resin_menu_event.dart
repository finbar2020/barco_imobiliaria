import 'package:lello/feature/resin/domain/entity/resin_params.dart';

abstract class ResinMenuEvent {
  ResinMenuEvent();
}

class ResinMenuLoadingsEvent extends ResinMenuEvent {}

class ResinMenuLoadedEvent extends ResinMenuEvent {
  ResinParams params;
  ResinMenuLoadedEvent({required this.params});
}

class ResinMenuErrorEvent extends ResinMenuEvent {
  String errorMessageKey;
  ResinMenuErrorEvent({required this.errorMessageKey});
}
