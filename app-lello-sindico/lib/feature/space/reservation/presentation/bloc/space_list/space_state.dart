import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class SpaceState {
  final List<Space> data;
  final String condominiumId;
  final List<Unit> unitsList;

  SpaceState(this.data, this.condominiumId, this.unitsList);
}

class SpaceLoadingState extends SpaceState {
  SpaceLoadingState(List<Space> data, String condominiumId, List<Unit> units)
      : super(data, condominiumId, units);
}

class SpaceLoadFailedState extends SpaceState {
  final Failure error;
  SpaceLoadFailedState(
      List<Space> data, String condominiumId, List<Unit> units, this.error)
      : super(data, condominiumId, units);
}

class SpaceLoadedState extends SpaceState {
  SpaceLoadedState(List<Space> data, String condominiumId, List<Unit> units)
      : super(data, condominiumId, units);
}
