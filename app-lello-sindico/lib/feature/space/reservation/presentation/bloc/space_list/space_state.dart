import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class SpaceState extends Equatable {
  final List<Space> data;
  final String condominiumId;
  final List<Unit> unitsList;

  const SpaceState(this.data, this.condominiumId, this.unitsList);

  @override
  List<Object?> get props => [data, condominiumId, unitsList];
}

class SpaceLoadingState extends SpaceState {
  const SpaceLoadingState(
      List<Space> data, String condominiumId, List<Unit> units)
      : super(data, condominiumId, units);
}

class SpaceLoadFailedState extends SpaceState {
  final Failure error;

  const SpaceLoadFailedState(
      List<Space> data, String condominiumId, List<Unit> units, this.error)
      : super(data, condominiumId, units);

  @override
  List<Object?> get props => [data, condominiumId, unitsList, error];
}

class SpaceLoadedState extends SpaceState {
  const SpaceLoadedState(
      List<Space> data, String condominiumId, List<Unit> units)
      : super(data, condominiumId, units);
}
