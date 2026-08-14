import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

class ReservationRaffleDetail extends ReservationRaffleData {
  Space? space;
  DateTime? date;
  DateTime? dateTo;
  ReservationTime? time;
}
