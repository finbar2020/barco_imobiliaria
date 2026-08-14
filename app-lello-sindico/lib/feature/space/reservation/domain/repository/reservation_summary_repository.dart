import 'package:essentials/essentials.dart';

import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';

abstract class ReservationSummaryRepository {
  Future<Try<SpaceCalendarResponse>> list(String condominiumId, String spaceId,
      DateTime periodStart, DateTime periodEnd, DataOrigin origin);
}
