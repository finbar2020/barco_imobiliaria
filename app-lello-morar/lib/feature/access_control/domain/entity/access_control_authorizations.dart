import 'package:morar/feature/access_control/domain/entity/access_control_gest_units.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_recurrence.dart';

import 'access_control.dart';

class AccessControlAuthorizations {
  String? id;
  String? idConcierge;
  String? idUnit;
  String? idGest;
  String? start;
  String? end;
  AccessControlRecurrence? recurrence;
  String? autorizationType;

  bool? useFacialBiometric;

  AccessControl? accessControl;
  AccessControlGestUnits? gestUnit;
  String? initHour;
  String? initMinute;
  String? endHour;
  String? endMinute;
  List<bool> choices = [false, false, false, false, false, false, false];

  DateTime get startDate =>
      DateTime.parse(start ?? DateTime.now().toIso8601String());
  DateTime get endDate =>
      DateTime.parse(end ?? start ?? DateTime.now().toIso8601String());

  String get recorrente {
    if (recurrence?.recurrenceType != null) {
      return "Recorrente";
    } else {
      return "Pontual";
    }
  }

  String get authType {
    if (autorizationType == "PHONE") {
      return "Interfonar";
    } else if (autorizationType == "ACESSO_GRANTED") {
      return "Recorrente";
    } else if (autorizationType == "PONTUAL") {
      return "Pontual";
    } else {
      return "Interfonar";
    }
  }

  String get getRecurrenceDays {
    if (choices.any((e) => e)) {
      List<String> days = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
      var retorno = [];
      choices
          .asMap()
          .forEach((index, value) {if (value) retorno.add(days[index]);});
      return retorno.join(", ");
    } else if (recurrence?.itens?.isNotEmpty == true) {
      List<String> days = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
      var retorno = [];
      recurrence?.itens!.asMap().forEach(
          (index, value) => retorno.add(days[value.recurrenceValue! - 1]));
      recurrence?.itens!.asMap().forEach((index, value) =>
          choices[days.indexOf(days[value.recurrenceValue! - 1])] = true);
      return retorno.join(", ");
    } else {
      return "";
    }
  }

  AccessControlAuthorizations({
    this.id,
    this.idConcierge,
    this.start,
    this.end,
    this.recurrence,
    this.accessControl,
    this.gestUnit,
    this.initHour,
    this.initMinute,
    this.endHour,
    this.endMinute,
    this.autorizationType,
    this.idGest,
    this.idUnit,
    this.useFacialBiometric,
  });

  @override
  String toString() {
    return 'AccessControlAuthorizations(id: $id, idConcierge: $idConcierge, start: $start, end: $end, recurrence: $recurrence, accessControl: $accessControl, gestUnit: $gestUnit)';
  }
}
