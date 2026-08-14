abstract class InactivityState {}

class TimeoutInitialState extends InactivityState {}

class TimeoutEmptyState extends InactivityState {}

class TimeoutExpiredState extends InactivityState {}

class ChangeTimeState extends InactivityState {
  int timer;
  ChangeTimeState({
    required this.timer,
  });
}
