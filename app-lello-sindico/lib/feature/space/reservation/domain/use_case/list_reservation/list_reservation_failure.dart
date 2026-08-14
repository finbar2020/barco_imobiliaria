import 'package:essentials/essentials.dart';

abstract class ListReservationFailure extends Failure {}

class UnitExceededReservationLimit extends ListReservationFailure {
  UnitExceededReservationLimit();
}
