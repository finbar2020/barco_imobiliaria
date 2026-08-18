import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/domain/entity/employee.dart';

abstract class QuickFixState {
  final List<Employee> data;
  final String? condominiumId;

  QuickFixState(this.data, this.condominiumId);
}

class QuickFixLoadingState extends QuickFixState {
  QuickFixLoadingState(List<Employee>? data, String? condominiumId)
      : super(data ?? [], condominiumId);
}

class QuickFixLoadFailedState extends QuickFixState {
  final Failure? error;

  QuickFixLoadFailedState(List<Employee> data, String condominiumId, this.error)
      : super(data, condominiumId);
}

class QuickFixLoadedState extends QuickFixState {
  QuickFixLoadedState(List<Employee> data, String condominiumId)
      : super(data, condominiumId);
}
