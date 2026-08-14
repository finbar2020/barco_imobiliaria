import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';

part 'reservation_raffle_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRaffleDataModel {
  DateTime? signUpLimitDate;
  DateTime? raffleDate;
  DateTime? date;
  DateTime? dateTo;
  String? participantType;
  List<String> participants;

  ReservationRaffleDataModel({this.participants = const []});

  factory ReservationRaffleDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRaffleDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRaffleDataModelToJson(this);

  static ReservationRaffleDataModel? fromEntity(
          ReservationRegistration registration,
          ReservationRaffleData? entity) =>
      entity == null
          ? null
          : (ReservationRaffleDataModel()
            ..signUpLimitDate = entity.signUpLimitDate
            ..raffleDate = entity.raffleDate
            ..participantType = enumToString(entity.participantType)
            ..participants = _getParticipant(entity));

  static List<String> _getParticipant(ReservationRaffleData entity) {
    switch (entity.participantType) {
      case RaffleParticipantType.group:
        return entity.participantGroups;
      case RaffleParticipantType.unit:
        return entity.participantUnits.map((e) => e.id!).toList();
      case RaffleParticipantType.resident:
        return entity.participantResidents.map((e) => e.id!).toList();
      default:
        return [];
    }
  }
}
