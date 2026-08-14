import 'package:morar/feature/reservation/domain/entity/space.dart';

class ReservationController {
  List<Space> spaces = [];

  bool isFreeAreaSelected = false;
  bool isPaidAreaSelected = false;
  bool isMovingAreaSelected = false;

  bool get shouldShowFilter {
    int conditionsMet = 0;

    if (spaces.any((space) =>
        space.reservationRule.chargeable == false && space.type!.id != "M")) {
      conditionsMet++;
    }

    if (spaces.any((space) => space.reservationRule.chargeable == true)) {
      conditionsMet++;
    }

    if (spaces.any((space) => space.type!.id == "M")) {
      conditionsMet++;
    }

    return conditionsMet >= 2;
  }

  bool get hasFreeArea => spaces.any((space) =>
      space.reservationRule.chargeable == false && space.type!.id != "M");
  bool get hasPaidArea =>
      spaces.any((space) => space.reservationRule.chargeable == true);
  bool get hasMovingArea => spaces.any((space) => space.type!.id == "M");

  List<Space> get filteredSpaces {
    List<Space> initialSpaces = spaces;
    List<Space> filtered = [];

    if (isFreeAreaSelected) {
      filtered.addAll(initialSpaces
          .where(
              (s) => s.reservationRule.chargeable == false && s.type!.id != "M")
          .toList());
    }

    if (isPaidAreaSelected) {
      filtered.addAll(initialSpaces
          .where((s) => s.reservationRule.chargeable == true)
          .toList());
    }

    if (isMovingAreaSelected) {
      filtered.addAll(initialSpaces.where((s) => s.type!.id == "M").toList());
    }
    if (filtered.isEmpty) {
      return initialSpaces.toList();
    }

    return filtered.toList();
  }

  void dispose() {
    spaces = [];
    isFreeAreaSelected = false;
    isPaidAreaSelected = false;
    isMovingAreaSelected = false;
  }
}
