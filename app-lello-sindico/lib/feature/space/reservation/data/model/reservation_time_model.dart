import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';

part 'reservation_time_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationTimeModel {
  DateTime? from;
  DateTime? to;

  ReservationTimeModel();

  factory ReservationTimeModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationTimeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationTimeModelToJson(this);

  static ReservationTimeModel? fromEntity(ReservationTime? entity) =>
      entity == null
          ? null
          : (ReservationTimeModel()
            ..from = entity.from
            ..to = entity.to);

  ReservationTime toEntity() => ReservationTime()
    ..from = this.from
    ..to = this.to;
}
