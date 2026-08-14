import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_result.dart';

part 'reservation_raffle_result_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRaffleResultModel {
  ResidentModel? winner;

  ReservationRaffleResultModel();

  factory ReservationRaffleResultModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRaffleResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRaffleResultModelToJson(this);

  static ReservationRaffleResultModel? fromEntity(
          ReservationRaffleResult? entity) =>
      entity == null
          ? null
          : (ReservationRaffleResultModel()
            ..winner = ResidentModel.fromEntity(entity.winner));

  ReservationRaffleResult toEntity() =>
      ReservationRaffleResult()..winner = winner?.toEntity();
}
