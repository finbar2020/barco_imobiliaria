import 'package:essentials/essentials.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';

abstract class GetCalendar
    extends UseCase<SpaceCalendarResponse, GetCalendarParam> {}

class GetCalendarParam {
  final String condominiumId;
  final String spaceId;
  final DateTime startDate;
  final DateTime endDate;

  GetCalendarParam({
    required this.condominiumId,
    required this.spaceId,
    required this.startDate,
    required this.endDate,
  });
}
