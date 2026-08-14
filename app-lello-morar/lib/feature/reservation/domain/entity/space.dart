import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/space_type.dart';

class Space {
  String? id;
  String? name;
  String? pictureUrl;
  String? fileUrl;
  SpaceType? type;
  String? description;
  int? capacity;
  Space? sharedSpace;
  ReservationRule reservationRule = ReservationRule();
  String? term;
}
