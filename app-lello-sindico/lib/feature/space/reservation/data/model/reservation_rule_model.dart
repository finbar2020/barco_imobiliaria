import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:lello/feature/space/domain/entity/reservation_payment_method.dart';
import 'package:lello/feature/space/domain/entity/reservation_value_type.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';

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
  String? paymentMethod;
  String? valueType;
  int? cancellationLimit;
  int? expirationDays;
  AccountModel? account;
  int? reservationRangeMinimum;
  int? reservationRangeMaximum;

  ReservationRuleModel();

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
            ..limitation = enumToString(entity.limitation)
            ..limit = entity.limit
            ..sendEmailToManager = entity.sendEmailToManager
            ..sendEmailToResident = entity.sendEmailToResident
            ..chargeable = entity.chargeable
            ..price = entity.price
            ..paymentMethod = enumToString(entity.paymentMethod)
            ..valueType = enumToString(entity.valueType)
            ..cancellationLimit = entity.cancellationLimit
            ..expirationDays = entity.expirationDays
            ..account = AccountModel.fromEntity(entity.account)
            ..reservationRangeMinimum = entity.reservationRangeMinimum
            ..reservationRangeMaximum = entity.reservationRangeMaximum);

  ReservationRule toEntity() => ReservationRule()
    ..blockedForSettlers = this.blockedForSettlers
    ..blockedForDefaulters = this.blockedForDefaulters
    ..blockageArticle = this.blockageArticle
    ..allDay = this.allDay
    ..openHour = this.openHour
    ..closeHour = this.closeHour
    ..defaultDuration = this.defaultDuration
    ..timeBetweenReservations = this.timeBetweenReservations
    ..limitation = stringToEnum(ReservationLimitation.values, this.limitation!)
    ..limit = this.limit
    ..sendEmailToManager = this.sendEmailToManager
    ..sendEmailToResident = this.sendEmailToResident
    ..chargeable = this.chargeable
    ..price = this.price
    ..paymentMethod = this.paymentMethod == null
        ? ReservationPaymentMethod.quota
        : stringToEnum(ReservationPaymentMethod.values, this.paymentMethod!)
    ..valueType = this.valueType == null
        ? ReservationValueType.percentage
        : stringToEnum(ReservationValueType.values, this.valueType!)
    ..cancellationLimit = this.cancellationLimit
    ..account = this.account?.toEntity()
    ..reservationRangeMinimum = this.reservationRangeMinimum
    ..reservationRangeMaximum = this.reservationRangeMaximum
    ..expirationDays = this.expirationDays;
}
