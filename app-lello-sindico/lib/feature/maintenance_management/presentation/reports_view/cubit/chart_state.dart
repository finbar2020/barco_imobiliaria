import 'package:essentials/essentials.dart';

/// Estados para gráficos individuais
abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object?> get props => [];
}

class ChartInitialState extends ChartState {}

class ChartLoadingState extends ChartState {}

class ChartLoadedState<T> extends ChartState {
  final T data;

  const ChartLoadedState(this.data);

  @override
  List<Object?> get props => [data];
}

class ChartErrorState extends ChartState {
  final String message;

  const ChartErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ChartEmptyState extends ChartState {
  final String message;

  const ChartEmptyState(this.message);

  @override
  List<Object> get props => [message];
}
