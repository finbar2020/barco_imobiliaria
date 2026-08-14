import '../../../../../core/dependency/application_container.dart';
import '../../home/bloc/maintenance_management_current_week/maintenance_management_current_week_bloc.dart';
import '../../home/bloc/maintenance_management_current_week/maintenance_management_current_week_event.dart';
import '../../home/widgets/task_summary/bloc/task_summary_bloc.dart';
import '../../home/widgets/task_summary/bloc/task_summary_event.dart';

/// Helper para recarregar os dados da semana atual de manutenção
/// Deve ser chamado após criar, editar ou excluir tarefas
class MaintenanceReloadHelper {
  /// Recarrega os dados da semana atual sem filtros aplicados
  static void reloadCurrentWeek() {
    final currentWeekBloc = ApplicationContainer.instance()
        .resolve<MaintenanceManagementCurrentWeekBloc>();

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Força reload da semana atual sem filtros
    currentWeekBloc.add(FetchMaintenanceTaskEventsEvent(
      dtStart: startOfWeek,
      untilDate: endOfWeek,
      dayCurrent: now,
      typeTask: [],
      status: [],
    ));

    // Limpa o cache do TaskSummaryCard para forçar reload
    try {
      final taskSummaryBloc = ApplicationContainer.instance()
          .resolve<TaskSummaryBloc>();
      taskSummaryBloc.add(ClearTaskSummaryCacheEvent());
    } catch (e) {
      // Se o BLoC não estiver registrado, ignora silenciosamente
      // Isso pode acontecer em testes ou em contextos onde o TaskSummaryCard não está sendo usado
    }
  }
}
