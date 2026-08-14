import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/data/model/space_model.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_registration.dart';

part 'reservation_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRegistrationModel {
  String? spaceId;
  SpaceModel? space;
  bool? flagUtilityTerm;
  String? reservationStartDate;
  String? reservationEndDate;
  String? unitId;
  String? reservationType;
  int? idStatus;

  ReservationRegistrationModel({
    this.spaceId,
    this.space,
    this.flagUtilityTerm,
    this.reservationStartDate,
    this.reservationEndDate,
    this.unitId,
    this.reservationType,
    this.idStatus,
  });

  factory ReservationRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRegistrationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRegistrationModelToJson(this);

  static ReservationRegistrationModel? fromEntity(
          ReservationRegistration? entity) =>
      entity == null
          ? null
          : (ReservationRegistrationModel()
            ..spaceId = entity.space?.id
            ..space = SpaceModel.fromEntity(entity.space)
            ..flagUtilityTerm = entity.flagUtilityTerm
            ..reservationStartDate = entity.reservationStartDate
            ..reservationEndDate = entity.reservationEndDate
            ..unitId = entity.unitId
            ..reservationType = entity.reservationType);

  ReservationRegistration toEntity() => ReservationRegistration()
    ..flagUtilityTerm = this.flagUtilityTerm
    ..idStatus = this.idStatus
    ..reservationEndDate = this.reservationEndDate
    ..reservationStartDate = this.reservationStartDate
    ..reservationType = this.reservationType
    ..space = this.space?.toEntity()
    ..spaceId = this.spaceId
    ..idStatus = this.idStatus;

  @override
  String toString() {
    return 'ReservationRegistrationModel(spaceId: $spaceId, space: $space, flagUtilityTerm: $flagUtilityTerm, reservationStartDate: $reservationStartDate, reservationEndDate: $reservationEndDate, unitId: $unitId, reservationType: $reservationType, idStatus: $idStatus)';
  }
}
