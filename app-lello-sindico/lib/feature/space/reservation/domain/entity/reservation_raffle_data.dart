import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class ReservationRaffleData {
  DateTime? signUpLimitDate;
  DateTime? raffleDate;
  RaffleParticipantType? participantType;
  List<Unit> participantUnits;
  List<String> participantGroups;
  List<Resident> participantResidents;
  ReservationRaffleData({
    this.participantUnits = const [],
    this.participantGroups = const [],
    this.participantResidents = const [],
  });
}

enum RaffleParticipantType { group, unit, resident }
