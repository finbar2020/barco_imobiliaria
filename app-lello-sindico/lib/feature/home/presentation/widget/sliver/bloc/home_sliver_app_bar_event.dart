abstract class HomeSliverAppBarEvent {}

class HomeSliverAppBarLockScrollEvent extends HomeSliverAppBarEvent {
  final bool isLocked;
  HomeSliverAppBarLockScrollEvent({required this.isLocked});
}
