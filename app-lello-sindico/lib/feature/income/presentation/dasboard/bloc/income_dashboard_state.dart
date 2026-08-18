import 'package:essentials/essentials.dart';

import '../../../domain/entity/income.dart';

abstract class IncomeDashboardState {}

class IncomeDashboardLoadingState extends IncomeDashboardState {}

class IncomeDashboardEmptyState extends IncomeDashboardState {}

class IncomeDashboardFailureState extends IncomeDashboardState {
  final Failure error;
  IncomeDashboardFailureState({required this.error});
}

class IncomeDashboardSuccessState extends IncomeDashboardState {
  final Income? income;
  IncomeDashboardSuccessState({this.income});
}
