import 'package:essentials/essentials.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

abstract class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc(super.initialState);

  Future<void> loadTaskDetails(String taskId);
  void changeTab(TaskDetailsTabType tabType);
}
