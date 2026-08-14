import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resident/data/model/resident_model.dart';
import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:lello/feature/space/reservation/data/model/reservation_time_model.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_detail.dart';
import 'package:lello/feature/unit/data/model/unit_model.dart';

part 'reservation_raffle_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationRaffleDetailModel {
  DateTime? signUpLimitDate;
  DateTime? raffleDate;
  String? participantType;
  List<UnitModel>? participantUnits;
  List<String>? participantGroups;
  List<ResidentModel>? participantResidents;
  SpaceModel? space;
  DateTime? date;
  DateTime? dateTo;
  ReservationTimeModel? time;

  ReservationRaffleDetailModel();

  factory ReservationRaffleDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationRaffleDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationRaffleDetailModelToJson(this);

  static ReservationRaffleDetailModel? fromEntity(
          ReservationRaffleDetail? entity) =>
      entity == null
          ? null
          : (ReservationRaffleDetailModel()
            ..signUpLimitDate = entity.signUpLimitDate
            ..raffleDate = entity.raffleDate
            ..participantType = enumToString(entity.participantType)
            ..participantUnits = entity.participantUnits
                .map((e) => UnitModel.fromEntity(e))
                .toList()
            ..participantGroups = entity.participantGroups
            ..participantResidents = entity.participantResidents
                .map((e) => ResidentModel.fromEntity(e)!)
                .toList()
            ..space = SpaceModel.fromEntity(entity.space)
            ..date = entity.date
            ..dateTo = entity.dateTo
            ..time = ReservationTimeModel.fromEntity(entity.time!));

  ReservationRaffleDetail toEntity() => ReservationRaffleDetail()
    ..signUpLimitDate = this.signUpLimitDate
    ..raffleDate = this.raffleDate
    ..participantType =
        stringToEnum(RaffleParticipantType.values, this.participantType!)
    ..participantUnits =
        this.participantUnits?.map((e) => e.toEntity()).toList() ?? []
    ..participantGroups = this.participantGroups ?? []
    ..participantResidents =
        this.participantResidents?.map((e) => e.toEntity()).toList() ?? []
    ..space = this.space?.toEntity()
    ..date = this.date
    ..dateTo = this.dateTo
    ..time = this.time?.toEntity();
}
