import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';

abstract class ListReservationSummary
    extends UseCase<SpaceCalendarResponse, ListReservationSummaryParam> {}

class ListReservationSummaryParam {
  final String condominiumId;
  final String spaceId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DataOrigin origin;

  ListReservationSummaryParam(
      {required this.condominiumId,
      required this.spaceId,
      required this.periodStart,
      required this.periodEnd,
      required this.origin});
}
