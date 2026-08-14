import 'package:essentials/essentials.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/domain/entity/session.dart';

abstract class SessionState extends Equatable {
  final Session? session;

  const SessionState(this.session);

  @override
  List<Object?> get props => [session];
}

class SessionEmptyState extends SessionState {
  const SessionEmptyState() : super(null);
}

class SessionLoadedState extends SessionState {
  final bool? switchFailed;
  final List<HomeNavigationItemEnum>? itens;

  const SessionLoadedState(
    Session super.session, {
    this.switchFailed,
    this.itens,
  });

  @override
  List<Object?> get props => [...super.props, switchFailed, itens];
}

class SessionLoadingState extends SessionState {
  const SessionLoadingState(Session super.session);
}

class SessionFailedState extends SessionState {
  final Failure failure;
  final Me? user;

  const SessionFailedState(this.failure, this.user) : super(null);

  @override
  List<Object?> get props => [failure, user];
}
