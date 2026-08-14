import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class BilletsEvent extends Equatable {
  const BilletsEvent();

  @override
  List<Object?> get props => [];
}

class BilletsEmptyEvent extends BilletsEvent {
  const BilletsEmptyEvent();
}

class BilletsSearchingEvent extends BilletsEvent {
  const BilletsSearchingEvent();
}

class BilletsLoadingEvent extends BilletsEvent {
  final List<Unit> units;

  const BilletsLoadingEvent({required this.units});

  @override
  List<Object?> get props => [units];
}

class UnitsLoadingEvent extends BilletsEvent {
  final List<Unit> units;

  const UnitsLoadingEvent({required this.units});

  @override
  List<Object?> get props => [units];
}

class BilletsLoadFailedEvent extends BilletsEvent {
  final Failure error;

  const BilletsLoadFailedEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class BilletsPagingEvent extends BilletsEvent {
  final List<Unit> units;

  const BilletsPagingEvent({required this.units});

  @override
  List<Object?> get props => [units];
}

class BilletsPageFailedEvent extends BilletsEvent {
  final Failure error;

  const BilletsPageFailedEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class BilletsLoadedEvent extends BilletsEvent {
  final List<Unit> units;

  const BilletsLoadedEvent({required this.units});

  @override
  List<Object?> get props => [units];
}

class BilletsNextPageEvent extends BilletsEvent {
  final BilletFilter filter;

  const BilletsNextPageEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class BilletsFilteredEvent extends BilletsEvent {
  final List<Unit> units;

  const BilletsFilteredEvent({required this.units});

  @override
  List<Object?> get props => [units];
}
