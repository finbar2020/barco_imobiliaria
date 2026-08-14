import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/data/model/condominium_model.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_change_rules.dart';

part 'reservation_change_rules_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationChangeRulesModel {
  String? idMovingRule;
  String? spaceId;
  CondominiumModel? condominio;
  String? weekHourStart;
  String? weekHourEnd;
  String? weekendHourStart;
  String? weekendHourEnd;
  int? daysInAdvance;
  int? allowedDays;
  List<int>? allowedDaysList;
  int? maxPerDay;

  ReservationChangeRulesModel({
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
    return 'ReservationChangeRulesModel(idMovingRule: $idMovingRule, spaceId: $spaceId, condominio: $condominio, weekHourStart: $weekHourStart, weekHourEnd: $weekHourEnd, weekendHourStart: $weekendHourStart, weekendHourEnd: $weekendHourEnd, daysInAdvance: $daysInAdvance, allowedDays: $allowedDays, allowedDaysList: $allowedDaysList, maxPerDay: $maxPerDay)';
  }

  factory ReservationChangeRulesModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationChangeRulesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationChangeRulesModelToJson(this);

  static ReservationChangeRulesModel? fromEntity(
          ReservationChangeRules? entity) =>
      entity == null
          ? null
          : (ReservationChangeRulesModel()
            ..idMovingRule = entity.idMovingRule
            ..spaceId = entity.spaceId
            ..condominio = CondominiumModel.fromEntity(entity.condominio)
            ..weekHourStart = entity.weekHourStart
            ..weekHourEnd = entity.weekHourEnd
            ..weekendHourStart = entity.weekendHourStart
            ..weekendHourEnd = entity.weekendHourEnd
            ..daysInAdvance = entity.daysInAdvance
            ..allowedDays = entity.allowedDays
            ..allowedDaysList = entity.allowedDaysList
            ..maxPerDay = entity.maxPerDay);

  ReservationChangeRules toEntity() => ReservationChangeRules()
    ..idMovingRule = this.idMovingRule
    ..spaceId = this.spaceId
    ..condominio = this.condominio?.toEntity()
    ..weekHourStart = this.weekHourStart
    ..weekHourEnd = this.weekHourEnd
    ..weekendHourStart = this.weekendHourStart
    ..weekendHourEnd = this.weekendHourEnd
    ..daysInAdvance = this.daysInAdvance
    ..allowedDays = this.allowedDays
    ..allowedDaysList = this.allowedDaysList
    ..maxPerDay = this.maxPerDay;
}
