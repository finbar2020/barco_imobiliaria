import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_sliver_app_bar_event.dart';
import 'home_sliver_app_bar_state.dart';

class HomeSliverAppBarBloc
    extends Bloc<HomeSliverAppBarEvent, HomeSliverAppBarState> {
  HomeSliverAppBarBloc() : super(const HomeSliverAppBarInitialState()) {
    on<HomeSliverAppBarLockScrollEvent>(_mapScrollLock);
  }

  Future<void> _mapScrollLock(
    HomeSliverAppBarLockScrollEvent event,
    Emitter<HomeSliverAppBarState> emit,
  ) async {
    emit(HomeSliverAppBarLockState(event.isLocked));
  }

  void beginLockScroll(bool isLocked) {
    add(HomeSliverAppBarLockScrollEvent(isLocked: isLocked));
  }
}

