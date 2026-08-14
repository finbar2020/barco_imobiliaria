import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class QuickFixState extends Equatable {
  final List<Employee> data;
  final String? condominiumId;

  const QuickFixState(this.data, this.condominiumId);

  @override
  List<Object?> get props => [data, condominiumId];
}

class QuickFixLoadingState extends QuickFixState {
  const QuickFixLoadingState(List<Employee>? data, String? condominiumId)
      : super(data ?? const <Employee>[], condominiumId);
}

class QuickFixLoadFailedState extends QuickFixState {
  final Failure? error;

  const QuickFixLoadFailedState(
      List<Employee> data, String condominiumId, this.error)
      : super(data, condominiumId);

  @override
  List<Object?> get props => [...super.props, error];
}

class QuickFixLoadedState extends QuickFixState {
  const QuickFixLoadedState(List<Employee> data, String condominiumId)
      : super(data, condominiumId);
}
