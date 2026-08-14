import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class Reservation {
  String? id;
  ReservationType? type;
  DateTime? from;
  DateTime? to;
  DateTime? expiration;
  Space? space;
  Unit? unit;
  double? price;
  String? receipt;
  DateTime? cancellationLimit;
  String? status;
}
