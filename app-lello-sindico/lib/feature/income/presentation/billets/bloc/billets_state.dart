import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class BilletsState {}

class BilletsEmptyState extends BilletsState {}

class BilletsSearchingState extends BilletsState {}

class BilletsLoadingState extends BilletsState {
  final List<Unit> units;
  BilletsLoadingState({required this.units});
}

class UnitsLoadingState extends BilletsState {
  final List<Unit> units;
  UnitsLoadingState({required this.units});
}

class BilletsLoadFailedState extends BilletsState {
  final Failure error;
  BilletsLoadFailedState({required this.error});
}

class BilletsPagingState extends BilletsLoadedState {
  BilletsPagingState({required List<Unit> units}) : super(units: units);
}

class BilletsPageFailedState extends BilletsState {
  final Failure error;
  BilletsPageFailedState({required this.error});
}

class BilletsLoadedState extends BilletsState {
  final List<Unit> units;

  BilletsLoadedState({
    required this.units,
  });
}

class BilletsNextPageState extends BilletsState {
  BilletFilter filter;
  BilletsNextPageState({required this.filter});
}

class BilletsFilteredState extends BilletsState {
  final List<Unit> units;

  BilletsFilteredState({required this.units});
}
