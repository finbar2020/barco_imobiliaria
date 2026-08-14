import 'package:lello/feature/condominium/domain/entity/condominium.dart';

class ReservationChangeRules {
  String? idMovingRule;
  String? spaceId;
  Condominium? condominio;
  String? weekHourStart;
  String? weekHourEnd;
  String? weekendHourStart;
  String? weekendHourEnd;
  int? daysInAdvance;
  int? allowedDays;
  List<int>? allowedDaysList;
  int? maxPerDay;

  int? setDays;
  ReservationChangeRules({
    this.idMovingRule,
    this.spaceId,
    this.condominio,
    this.weekHourStart,
    this.weekHourEnd,
    this.weekendHourStart,
    this.weekendHourEnd,
    this.daysInAdvance,
    this.allowedDays,
    this.allowedDaysList,
    this.maxPerDay,
  });

  @override
  String toString() {
    return 'ReservationChangeRules(idMovingRule: $idMovingRule, spaceId: $spaceId, condominio: $condominio, weekHourStart: $weekHourStart, weekHourEnd: $weekHourEnd, weekendHourStart: $weekendHourStart, weekendHourEnd: $weekendHourEnd, daysInAdvance: $daysInAdvance, allowedDays: $allowedDays, allowedDaysList: $allowedDaysList, maxPerDay: $maxPerDay)';
  }

  int get diasAntecedencia {
    if (daysInAdvance == 0 || daysInAdvance == null) {
      return 9;
    } else if (daysInAdvance == 1) {
      return 0;
    } else if (daysInAdvance == 2) {
      return 1;
    } else if (daysInAdvance! < 7) {
      return 2;
    } else if (daysInAdvance! >= 7 && daysInAdvance! < 14) {
      return 3;
    } else if (daysInAdvance! >= 14 && daysInAdvance! < 21) {
      return 4;
    } else if (daysInAdvance! >= 21 && daysInAdvance! < 30) {
      return 5;
    } else if (daysInAdvance! >= 30 && daysInAdvance! < 60) {
      return 6;
    } else if (daysInAdvance! >= 60 && daysInAdvance! < 90) {
      return 7;
    } else if (daysInAdvance! >= 90) {
      return 8;
    }
    return 9;
  }

  int setDiasAntecedencia(int? value) {
    if (value == 0) {
      return 1;
    } else if (value == 1) {
      return 2;
    } else if (value == 2) {
      return 3;
    } else if (value == 3) {
      return 7;
    } else if (value == 4) {
      return 14;
    } else if (value == 5) {
      return 21;
    } else if (value == 6) {
      return 30;
    } else if (value == 7) {
      return 60;
    } else if (value == 8) {
      return 90;
    } else if (value == 9) {
      return 0;
    }
    return 9;
  }
}
