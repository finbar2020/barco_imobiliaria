import 'package:essentials/essentials.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/domain/entity/session.dart';

abstract class SessionState extends Equatable {
  final Session? session;

  const SessionState(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionInitialState extends SessionState {
  const SessionInitialState() : super(null);
}

class SessionLoadedState extends SessionState {
  final bool? switchFailed;

  const SessionLoadedState(Session session, {this.switchFailed})
      : super(session);

  @override
  List<Object?> get props => [session, switchFailed];
}

class SessionLoadingState extends SessionState {
  const SessionLoadingState(Session session) : super(session);
}

class SessionFailedState extends SessionState {
  final Failure failure;
  final Me? user;

  const SessionFailedState(this.failure, this.user) : super(null);

  @override
  List<Object?> get props => [failure, user];
}
