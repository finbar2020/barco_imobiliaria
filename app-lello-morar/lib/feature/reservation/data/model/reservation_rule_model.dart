import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';

part 'reservation_rule_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRuleModel {
  bool? blockedForSettlers;
  bool? blockedForDefaulters;
  String? blockageArticle;
  bool? allDay;
  int? openHour;
  int? closeHour;
  int? defaultDuration;
  int? timeBetweenReservations;
  String? limitation;
  int? limit;
  bool? sendEmailToManager;
  bool? sendEmailToResident;
  bool? chargeable;
  double? price;
  double? percentageTax;
  String? paymentMethod;
  int? cancellationLimit;
  int? expirationDays;
  int? reservationRangeMinimum;
  int? reservationRangeMaximum;

  ReservationRuleModel({
    this.blockedForSettlers,
    this.blockedForDefaulters,
    this.blockageArticle,
    this.allDay,
    this.openHour,
    this.closeHour,
    this.defaultDuration,
    this.timeBetweenReservations,
    this.limitation,
    this.limit,
    this.sendEmailToManager,
    this.sendEmailToResident,
    this.chargeable,
    this.price,
    this.percentageTax,
    this.paymentMethod,
    this.cancellationLimit,
    this.expirationDays,
    this.reservationRangeMinimum,
    this.reservationRangeMaximum,
  });

  factory ReservationRuleModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRuleModelToJson(this);

  static ReservationRuleModel? fromEntity(ReservationRule? entity) =>
      entity == null
          ? null
          : (ReservationRuleModel()
            ..blockedForSettlers = entity.blockedForSettlers
            ..blockedForDefaulters = entity.blockedForDefaulters
            ..blockageArticle = entity.blockageArticle
            ..allDay = entity.allDay
            ..openHour = entity.openHour
            ..closeHour = entity.closeHour
            ..defaultDuration = entity.defaultDuration
            ..timeBetweenReservations = entity.timeBetweenReservations
            ..limitation = _limitationName(entity.limitation)
            ..limit = entity.limit
            ..sendEmailToManager = entity.sendEmailToManager
            ..sendEmailToResident = entity.sendEmailToResident
            ..chargeable = entity.chargeable
            ..price = entity.price
            ..paymentMethod = entity.paymentMethod
            ..cancellationLimit = entity.cancellationLimit
            ..expirationDays = entity.expirationDays
            ..reservationRangeMinimum = entity.reservationRangeMinimum
            ..reservationRangeMaximum = entity.reservationRangeMaximum);

  ReservationRule toEntity() => ReservationRule()
    ..percentageTax = this.percentageTax
    ..blockedForSettlers = this.blockedForSettlers
    ..blockedForDefaulters = this.blockedForDefaulters
    ..blockageArticle = this.blockageArticle
    ..allDay = this.allDay
    ..openHour = this.openHour
    ..closeHour = this.closeHour
    ..defaultDuration = this.defaultDuration
    ..timeBetweenReservations = this.timeBetweenReservations
    ..limitation = _limitationEnum(this.limitation).toString()
    ..limit = this.limit
    ..sendEmailToManager = this.sendEmailToManager
    ..sendEmailToResident = this.sendEmailToResident
    ..chargeable = this.chargeable
    ..price = this.price
    ..paymentMethod = this.paymentMethod
    ..cancellationLimit = this.cancellationLimit
    ..reservationRangeMinimum = this.reservationRangeMinimum
    ..reservationRangeMaximum = this.reservationRangeMaximum
    ..expirationDays = this.expirationDays;

  /// Aceita tanto o nome do enum ("day") quanto o `toString()`
  /// ("ReservationLimitation.day"); nulo/desconhecido cai em `none`.
  static ReservationLimitation _limitationEnum(String? value) {
    if (value == null) return ReservationLimitation.none;
    final name = value.contains('.') ? value.split('.').last : value;
    return stringToEnum(ReservationLimitation.values, name) ??
        ReservationLimitation.none;
  }

  static String _limitationName(String? value) =>
      enumToString(_limitationEnum(value))!;
}
