import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

part 'reservation_registration_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRegistrationDataModel {
  String? spaceId;
  DateTime? date;
  DateTime? dateTo;
  String? type;
  String? unitId;

  ReservationRegistrationDataModel();

  factory ReservationRegistrationDataModel.fromJson(
          Map<String, dynamic> json) =>
      _$ReservationRegistrationDataModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ReservationRegistrationDataModelToJson(this);

  static ReservationRegistrationDataModel? fromEntity(
          ReservationRegistration? entity, String unitId) =>
      entity == null
          ? null
          : (ReservationRegistrationDataModel()
            ..unitId = unitId
            ..spaceId = entity.space?.id);
}
