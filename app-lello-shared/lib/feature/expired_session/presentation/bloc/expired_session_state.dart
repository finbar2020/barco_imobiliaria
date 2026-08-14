part of shared_features;

abstract class ExpiredSessionState extends Equatable {
  const ExpiredSessionState();

  @override
  List<Object?> get props => [];
}

class ExpiredSessionEmptyState extends ExpiredSessionState {
  const ExpiredSessionEmptyState();
}

class ExpiredSessionLogOutLoadingState extends ExpiredSessionState {
  const ExpiredSessionLogOutLoadingState();
}

class ExpiredSessionLogOutLoadedState extends ExpiredSessionState {
  const ExpiredSessionLogOutLoadedState();
}
