import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_features/feature/gdp/domain/use_case/get_employee/get_employee.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_event.dart';
import 'package:shared_features/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:shared_features/shared_features.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SharedSession? sessionBloc;
  final GetEmployee getEmployee;
  StreamSubscription? _subscription;

  EmployeeBloc({required this.sessionBloc, required this.getEmployee})
      : super(const EmployeeLoadingState(null, null)) {
    on<EmployeeLoadEvent>(_mapLoad);
  }

  Future<void> _mapLoad(
    EmployeeLoadEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final condominiumId = event.condominiumId;
    final data = state.data;

    emit(EmployeeLoadingState(data, condominiumId));

    final result = await getEmployee.call(GetEmployeeParam(
        condominiumId: condominiumId, employeeId: event.employeeId));
    emit(result.fold(
        (err) => EmployeeLoadFailedState(data!, condominiumId, err),
        (res) => EmployeeLoadedState(res, condominiumId)));
  }

  void beginLoad(String employeeId) {
    if (sessionBloc?.condominiumId != null) {
      add(EmployeeLoadEvent(
          employeeId: employeeId, condominiumId: sessionBloc!.condominiumId));
    }
  }

  @override
  Future<void> close() {
    if (_subscription != null) _subscription?.cancel();
    return super.close();
  }
}
