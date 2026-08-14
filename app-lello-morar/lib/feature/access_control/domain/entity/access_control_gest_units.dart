import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';

class AccessControlGestUnits {
  String? idGestUnit;
  Unity? unit;
  String? relation;
  String? autorizationType;
  String? observation;
  List<AccessControlAuthorizations> authorizations;
  int? autorizationTypeInt;
  AccessControlGestUnits({
    required this.authorizations,
    this.idGestUnit,
    this.unit,
    this.relation,
    this.autorizationType,
    this.observation,
    this.autorizationTypeInt,
  });

  bool get recorrente => autorizationType == "ACESSO_GRANTED";

  String get authType {
    if (recorrente) {
      return "Recorrente";
    } else {
      return "Interfonar";
    }
  }

  String get editAuthTypeVisit {
    if (recorrente) {
      return "Recorrente";
    } else {
      return "Pontual";
    }
  }

  @override
  String toString() {
    return 'AccessControlGestUnits(idGestUnit: $idGestUnit, unit: $unit, relation: $relation, autorizationType: $autorizationType, observation: $observation, authorizations: $authorizations, autorizationTypeInt: $autorizationTypeInt)';
  }
}
