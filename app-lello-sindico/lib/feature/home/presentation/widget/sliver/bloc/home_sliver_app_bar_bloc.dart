import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_sliver_app_bar_event.dart';
import 'home_sliver_app_bar_state.dart';

abstract class HomeSliverAppBarBloc
    extends Bloc<HomeSliverAppBarEvent, HomeSliverAppBarState> {
  HomeSliverAppBarBloc(HomeSliverAppBarState initialState)
      : super(initialState);

  void beginLockScroll(bool isLocked);
}
