import 'package:essentials/essentials.dart';

import '../../../domain/entity/income.dart';

abstract class IncomeDashboardState extends Equatable {
  const IncomeDashboardState();

  @override
  List<Object?> get props => [];
}

class IncomeDashboardLoadingState extends IncomeDashboardState {
  const IncomeDashboardLoadingState();
}

class IncomeDashboardEmptyState extends IncomeDashboardState {
  const IncomeDashboardEmptyState();
}

class IncomeDashboardFailureState extends IncomeDashboardState {
  final Failure error;

  const IncomeDashboardFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class IncomeDashboardSuccessState extends IncomeDashboardState {
  final Income? income;

  const IncomeDashboardSuccessState({this.income});

  @override
  List<Object?> get props => [income];
}
