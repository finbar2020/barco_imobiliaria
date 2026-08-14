import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:essentials/essentials.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitialState extends SessionState {
  const SessionInitialState();
}

class SessionLoadingState extends SessionState {
  const SessionLoadingState();
}

class SessionLoadedState extends SessionState {
  final Session session;

  SessionLoadedState({
    required this.session,
    required bool isTabletSession,
  }) {
    session.me.isTabletSession = isTabletSession;
  }

  @override
  List<Object?> get props => [session];
}

class SessionFailedState extends SessionState {
  final Failure error;

  const SessionFailedState({
    required this.error,
  });

  @override
  List<Object?> get props => [error];
}

class SessionExpiredTabletState extends SessionState {
  const SessionExpiredTabletState();
}
