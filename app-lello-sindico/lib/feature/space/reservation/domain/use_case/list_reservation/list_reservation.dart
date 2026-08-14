import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ListReservation
    extends UseCase<List<SpaceAvailableHours>, ListReservationParam> {}

class ListReservationParam {
  final String condominiumId;
  final String? unitId;
  final String spaceId;
  final DateTime date;

  ListReservationParam(
      {required this.condominiumId,
      this.unitId,
      required this.spaceId,
      required this.date});
}
