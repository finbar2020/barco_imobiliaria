import 'package:morar/feature/reservation/domain/entity/space.dart';

class Reservation {
  String? id;
  String? type;
  DateTime? from;
  DateTime? to;
  DateTime? expiration;
  Space? space;
  // Unit unit;
  double? price;
  String? receipt;
  DateTime? cancellationLimit;
  String? status;
}
