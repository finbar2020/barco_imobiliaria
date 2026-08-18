
class HomeSliverAppBarState {
	final bool lockScroll;

	HomeSliverAppBarState(this.lockScroll);
}

class HomeSliverAppBarLockState extends HomeSliverAppBarState {
	HomeSliverAppBarLockState(bool isLocked) : super(isLocked);
}
