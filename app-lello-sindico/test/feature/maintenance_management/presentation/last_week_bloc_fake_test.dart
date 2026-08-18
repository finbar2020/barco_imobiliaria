import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/repository/maintenance_management_repository.dart';
import 'package:lello/feature/maintenance_management/presentation/enums/efficiency_scope_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_bloc_impl.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';

class _FakeRepo extends Fake implements MaintenanceManagementRepository {
  _FakeRepo(this.result);

  Try<EfficiencyResponseEntity> result;
  bool throwError = false;
  String? lastDisplayBy;

  @override
  Future<Try<EfficiencyResponseEntity>> getMaintenanceTasksEfficiency({
    required String dtStart,
    required String untilDate,
    required List<String> typeTask,
    required String dayCurrent,
    required List<String> procedureGroupLabels,
    required List<String> procedureGroupIds,
    required List<String> responsibleIds,
    required String displayBy,
    required List<String> status,
    String? pageName,
  }) async {
    lastDisplayBy = displayBy;
    if (throwError) throw Exception('falhou');
    return result;
  }
}

EfficiencyResponseEntity _data() {
  return EfficiencyResponseEntity(
    efficiencyResponse: [
      EfficiencyItemEntity(id: '1', name: 'Ana', done: 2, notStarted: 1, draft: 0),
    ],
    taskSummary: TaskSummaryEntity(total: 3, done: 2, notStarted: 1, draft: 0),
  );
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 50));

  test('carrega, busca, troca escopo, erro e exceção', () async {
    final repo = _FakeRepo(Success(_data()));
    final bloc = MaintenanceManagementLastWeekBlocImpl(repo);
    addTearDown(bloc.close);

    bloc.add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: DateTime(2026, 1, 5),
      endDate: DateTime(2026, 1, 11),
    ));
    await wait();
    expect(bloc.state, isA<MaintenanceManagementLastWeekLoadedState>());
    expect(repo.lastDisplayBy, 'RESPONSAVEL');

    bloc.searchEfficiency('Ana');
    await wait();
    expect(
      (bloc.state as MaintenanceManagementLastWeekLoadedState).searchQuery,
      'Ana',
    );

    bloc.changeScope(EfficiencyScope.groups);
    await wait();
    expect(repo.lastDisplayBy, 'GRUPO');
    expect(
      (bloc.state as MaintenanceManagementLastWeekLoadedState).currentScope,
      EfficiencyScope.groups,
    );

    repo.result = Rejection(UnknownFailure('boom'));
    bloc.add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: DateTime(2026, 1, 12),
      endDate: DateTime(2026, 1, 18),
    ));
    await wait();
    expect(bloc.state, isA<MaintenanceManagementLastWeekErrorState>());

    repo.result = Success(_data());
    bloc.add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: DateTime(2026, 1, 19),
      endDate: DateTime(2026, 1, 25),
    ));
    await wait();
    repo.throwError = true;
    bloc.changeScope(EfficiencyScope.responsibles);
    await wait();
    expect(bloc.state, isA<MaintenanceManagementLastWeekErrorState>());

    repo.throwError = true;
    bloc.add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: DateTime(2026, 2, 1),
      endDate: DateTime(2026, 2, 7),
    ));
    await wait();
    expect(bloc.state, isA<MaintenanceManagementLastWeekErrorState>());

    repo.throwError = false;
    repo.result = Success(_data());
    bloc.fetchEfficiencyData();
    await wait();
    expect(bloc.state, isA<MaintenanceManagementLastWeekLoadedState>());
  });
}
