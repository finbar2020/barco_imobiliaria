import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationFilterState extends Equatable {
  final List<Space> spaces;
  final List<Unit> units;
  final String condominiumId;

  const ReservationFilterState(this.spaces, this.units, this.condominiumId);

  @override
  List<Object?> get props => [spaces, units, condominiumId];
}

class ReservationFilterLoadingState extends ReservationFilterState {
  const ReservationFilterLoadingState(
      List<Space> spaces, List<Unit> units, String condominiumId)
      : super(spaces, units, condominiumId);
}

class ReservationFilterLoadFailedState extends ReservationFilterState {
  final Failure error;

  const ReservationFilterLoadFailedState(
      List<Space> spaces, List<Unit> units, String condominiumId, this.error)
      : super(spaces, units, condominiumId);

  @override
  List<Object?> get props => [spaces, units, condominiumId, error];
}

class ReservationFilterLoadedState extends ReservationFilterState {
  const ReservationFilterLoadedState(
      List<Space> spaces, List<Unit> units, String condominiumId)
      : super(spaces, units, condominiumId);
}
