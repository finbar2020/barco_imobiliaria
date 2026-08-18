import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationFilterState {
  final List<Space> spaces;
  final List<Unit> units;
  final String condominiumId;

  ReservationFilterState(this.spaces, this.units, this.condominiumId);
}

class ReservationFilterLoadingState extends ReservationFilterState {
  ReservationFilterLoadingState(
      List<Space> spaces, List<Unit> units, String condominiumId)
      : super(spaces, units, condominiumId);
}

class ReservationFilterLoadFailedState extends ReservationFilterState {
  final Failure error;
  ReservationFilterLoadFailedState(
      List<Space> spaces, List<Unit> units, String condominiumId, this.error)
      : super(spaces, units, condominiumId);
}

class ReservationFilterLoadedState extends ReservationFilterState {
  ReservationFilterLoadedState(
      List<Space> spaces, List<Unit> units, String condominiumId)
      : super(spaces, units, condominiumId);
}
