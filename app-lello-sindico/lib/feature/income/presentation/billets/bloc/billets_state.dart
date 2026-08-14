import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/billet_filter_parameters.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class BilletsState extends Equatable {
  const BilletsState();

  @override
  List<Object?> get props => [];
}

class BilletsEmptyState extends BilletsState {
  const BilletsEmptyState();
}

class BilletsSearchingState extends BilletsState {
  const BilletsSearchingState();
}

class BilletsLoadingState extends BilletsState {
  final List<Unit> units;

  const BilletsLoadingState({required this.units});

  @override
  List<Object?> get props => [units];
}

class UnitsLoadingState extends BilletsState {
  final List<Unit> units;

  const UnitsLoadingState({required this.units});

  @override
  List<Object?> get props => [units];
}

class BilletsLoadFailedState extends BilletsState {
  final Failure error;

  const BilletsLoadFailedState({required this.error});

  @override
  List<Object?> get props => [error];
}

class BilletsLoadedState extends BilletsState {
  final List<Unit> units;

  const BilletsLoadedState({required this.units});

  @override
  List<Object?> get props => [units];
}

class BilletsPagingState extends BilletsLoadedState {
  const BilletsPagingState({required super.units});
}

class BilletsPageFailedState extends BilletsState {
  final Failure error;

  const BilletsPageFailedState({required this.error});

  @override
  List<Object?> get props => [error];
}

class BilletsNextPageState extends BilletsState {
  final BilletFilter filter;

  const BilletsNextPageState({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class BilletsFilteredState extends BilletsState {
  final List<Unit> units;

  const BilletsFilteredState({required this.units});

  @override
  List<Object?> get props => [units];
}
