import 'package:lello/feature/space/data/model/space_calendar_model.dart';

abstract class ReservationSummaryRemoteDataSource {
  Future<SpaceCalendarModel> list(String condominiumId, String spaceId,
      DateTime periodStart, DateTime periodEnd);
}
