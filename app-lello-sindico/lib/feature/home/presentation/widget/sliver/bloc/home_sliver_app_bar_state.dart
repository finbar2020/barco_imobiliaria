import 'package:essentials/essentials.dart';

abstract class HomeSliverAppBarState extends Equatable {
  final bool lockScroll;

  const HomeSliverAppBarState(this.lockScroll);

  @override
  List<Object?> get props => [lockScroll];
}

class HomeSliverAppBarInitialState extends HomeSliverAppBarState {
  const HomeSliverAppBarInitialState([super.lockScroll = false]);
}

class HomeSliverAppBarLockState extends HomeSliverAppBarState {
  const HomeSliverAppBarLockState(bool isLocked) : super(isLocked);
}
