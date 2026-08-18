import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class BilletsEvent {}

class BilletsEmptyEvent extends BilletsEvent {}

class BilletsSearchingEvent extends BilletsEvent {}

class BilletsLoadingEvent extends BilletsEvent {
  final List<Unit> units;
  BilletsLoadingEvent({required this.units});
}

class UnitsLoadingEvent extends BilletsEvent {
  final List<Unit> units;
  UnitsLoadingEvent({required this.units});
}

class BilletsLoadFailedEvent extends BilletsEvent {
  final Failure error;
  BilletsLoadFailedEvent({required this.error});
}

class BilletsPagingEvent extends BilletsEvent {
  final List<Unit> units;

  BilletsPagingEvent({
    required this.units,
  });
}

class BilletsPageFailedEvent extends BilletsEvent {
  final Failure error;
  BilletsPageFailedEvent({required this.error});
}

class BilletsLoadedEvent extends BilletsEvent {
  final List<Unit> units;

  BilletsLoadedEvent({
    required this.units,
  });
}

class BilletsNextPageEvent extends BilletsEvent {
  BilletFilter filter;
  BilletsNextPageEvent({
    required this.filter,
  });
}

class BilletsFilteredEvent extends BilletsEvent {
  final List<Unit> units;

  BilletsFilteredEvent({
    required this.units,
  });
}
