import 'package:essentials/essentials.dart';

import '../../../domain/entity/income.dart';

abstract class IncomeDashboardEvent {}

class IncomeDashboardSuccessEvent extends IncomeDashboardEvent {
  final Income? income;
  IncomeDashboardSuccessEvent({this.income});
}

class IncomeDashboardFailureEvent extends IncomeDashboardEvent {
  final Failure error;
  IncomeDashboardFailureEvent({
    required this.error,
  });
}

class IncomeDashboardLoadingEvent extends IncomeDashboardEvent {}
