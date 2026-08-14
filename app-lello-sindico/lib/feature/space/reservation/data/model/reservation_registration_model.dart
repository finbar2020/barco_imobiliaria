import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

part 'reservation_registration_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRegistrationModel {
  String? spaceId;
  SpaceModel? space;
  bool? flagUtilityTerm;
  DateTime? reservationStartDate;
  DateTime? reservationEndDate;
  String? unitId;
  String? reservationType;
  int? idStatus;

  ReservationRegistrationModel();

  factory ReservationRegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRegistrationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRegistrationModelToJson(this);

  static ReservationRegistrationModel? fromEntity(
          ReservationRegistration? entity) =>
      entity == null
          ? null
          : (ReservationRegistrationModel()
            ..spaceId = entity.space?.id
            ..flagUtilityTerm = entity.flagUtilityTerm
            ..reservationStartDate = entity.reservationStartDate
            ..reservationEndDate = entity.reservationEndDate
            ..unitId = entity.unitId
            ..reservationType = entity.reservationType);

  ReservationRegistration? toEntity() => ReservationRegistration()
    ..flagUtilityTerm = this.flagUtilityTerm
    ..idStatus = this.idStatus
    ..reservationEndDate = this.reservationEndDate
    ..reservationStartDate = this.reservationStartDate
    ..reservationType = this.reservationType
    ..spaceId = this.spaceId
    ..idStatus = this.idStatus;
}
