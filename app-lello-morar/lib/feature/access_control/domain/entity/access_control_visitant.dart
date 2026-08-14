import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';

class AccessControlVisitant {
  String? idGestUnit;
  int? autorizarionType;
  String? observation;
  AccessControl? gest;
  List<Unity> units;

  AccessControlVisitant({
    this.idGestUnit,
    this.autorizarionType,
    this.observation,
    this.gest,
    this.units = const [],
  });
}
