import 'dart:async';

import 'home_sliver_app_bar_bloc.dart';
import 'home_sliver_app_bar_event.dart';
import 'home_sliver_app_bar_state.dart';

class HomeSliverAppBarBlocImpl extends HomeSliverAppBarBloc {
  HomeSliverAppBarBlocImpl() : super(HomeSliverAppBarState(false));

  @override
  Stream<HomeSliverAppBarState> mapEventToState(
      HomeSliverAppBarEvent event) async* {
    if (event is HomeSliverAppBarLockScrollEvent) yield* _mapScrollLock(event);
  }

  Stream<HomeSliverAppBarState> _mapScrollLock(
      HomeSliverAppBarLockScrollEvent event) async* {
    yield HomeSliverAppBarLockState(event.isLocked);
  }

  @override
  void beginLockScroll(bool isLocked) {
    add(HomeSliverAppBarLockScrollEvent(isLocked: isLocked));
  }
}
