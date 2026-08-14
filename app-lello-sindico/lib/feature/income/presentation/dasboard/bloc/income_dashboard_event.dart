import 'package:essentials/essentials.dart';

import '../../../domain/entity/income.dart';

abstract class IncomeDashboardEvent extends Equatable {
  const IncomeDashboardEvent();

  @override
  List<Object?> get props => [];
}

class IncomeDashboardSuccessEvent extends IncomeDashboardEvent {
  final Income? income;

  const IncomeDashboardSuccessEvent({this.income});

  @override
  List<Object?> get props => [income];
}

class IncomeDashboardFailureEvent extends IncomeDashboardEvent {
  final Failure error;

  const IncomeDashboardFailureEvent({required this.error});

  @override
  List<Object?> get props => [error];
}

class IncomeDashboardLoadingEvent extends IncomeDashboardEvent {
  const IncomeDashboardLoadingEvent();
}
