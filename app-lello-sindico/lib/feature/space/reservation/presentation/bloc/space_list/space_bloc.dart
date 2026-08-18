import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/space_list/space_state.dart';

abstract class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc(SpaceState initialState) : super(initialState);

  void beginRefresh();
}
