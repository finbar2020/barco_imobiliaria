import 'dart:io';

import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';

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

  File? pendingPicture;
  File? pendingFile;
}
