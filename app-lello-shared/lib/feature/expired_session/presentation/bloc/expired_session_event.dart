part of shared_features;

abstract class ExpiredSessionEvent extends Equatable {
  const ExpiredSessionEvent();

  @override
  List<Object?> get props => [];
}

class ExpiredSessionLogOutEvent extends ExpiredSessionEvent {
  final ExpiredSessionArguments? args;

  const ExpiredSessionLogOutEvent(this.args);

  @override
  List<Object?> get props => [args];
}
