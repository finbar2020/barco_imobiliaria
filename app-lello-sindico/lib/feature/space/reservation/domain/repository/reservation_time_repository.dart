import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

abstract class ReservationTimeRepository {
  Future<Try<List<ReservationTime>>> list(
      String condominiumId, String spaceId, DateTime date);
}
