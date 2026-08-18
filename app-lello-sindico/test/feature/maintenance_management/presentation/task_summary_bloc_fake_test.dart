import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/efficiency_entity.dart';
import 'package:lello/feature/maintenance_management/domain/use_cases/get_task_summary_use_case.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/bloc/task_summary_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/bloc/task_summary_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/bloc/task_summary_state.dart';

class _FakeGetSummary extends Fake implements GetTaskSummaryUseCase {
  _FakeGetSummary(this.result);

  Try<TaskSummaryEntity> result;
  int calls = 0;

  @override
  Future<Try<TaskSummaryEntity>> call(GetTaskSummaryRequest request) async {
    calls++;
    return result;
  }
}

void main() {
  Future<void> wait() => Future<void>.delayed(const Duration(milliseconds: 40));

  test('carrega, usa cache e limpa', () async {
    final get = _FakeGetSummary(
      Success(TaskSummaryEntity(total: 3, done: 1, notStarted: 1, draft: 1)),
    );
    final bloc = TaskSummaryBloc(getTaskSummaryUseCase: get);
    addTearDown(bloc.close);

    bloc.add(LoadTaskSummaryEvent(dtStart: '01/01/2026', untilDate: '07/01/2026'));
    await wait();
    expect(bloc.state, isA<TaskSummaryLoadedState>());
    expect((bloc.state as TaskSummaryLoadedState).taskSummary.total, 3);

    bloc.add(LoadTaskSummaryEvent(dtStart: '01/01/2026', untilDate: '07/01/2026'));
    await wait();
    expect(get.calls, 1);

    bloc.add(ClearTaskSummaryCacheEvent());
    await wait();
    expect(bloc.state, isA<TaskSummaryInitialState>());

    bloc.add(LoadTaskSummaryEvent(dtStart: '01/01/2026', untilDate: '07/01/2026'));
    await wait();
    expect(get.calls, 2);
  });

  test('emite erro', () async {
    final bloc = TaskSummaryBloc(
      getTaskSummaryUseCase: _FakeGetSummary(Rejection(UnknownFailure('boom'))),
    );
    addTearDown(bloc.close);
    bloc.add(LoadTaskSummaryEvent(dtStart: 'a', untilDate: 'b'));
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(bloc.state, isA<TaskSummaryErrorState>());
  });
}
