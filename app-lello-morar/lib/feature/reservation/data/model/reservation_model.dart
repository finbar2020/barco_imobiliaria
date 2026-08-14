import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/data/model/space_model.dart';
import 'package:morar/feature/reservation/domain/entity/reservation.dart';

part 'reservation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationModel {
  String? id;
  String? type;
  DateTime? from;
  DateTime? to;
  DateTime? expiration;
  SpaceModel? space;
  double? price;
  String? receipt;
  DateTime? cancellationLimit;
  String? status;

  ReservationModel();

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);

  static ReservationModel? fromEntity(Reservation? entity) => entity == null
      ? null
      : (ReservationModel()
        ..id = entity.id
        ..type = entity.type
        ..from = entity.from
        ..to = entity.to
        ..expiration = entity.expiration
        ..space = SpaceModel.fromEntity(entity.space)
        ..price = entity.price
        ..receipt = entity.receipt
        ..cancellationLimit = entity.cancellationLimit
        ..status = entity.status);

  Reservation toEntity() => Reservation()
    ..id = this.id
    ..type = this.type
    ..from = this.from
    ..to = this.to
    ..expiration = this.expiration
    ..space = this.space?.toEntity()
    ..price = this.price
    ..receipt = this.receipt
    ..cancellationLimit = this.cancellationLimit
    ..status = this.status;
}
