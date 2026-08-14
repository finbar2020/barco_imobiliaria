import 'package:lello/feature/maintenance_management/domain/entity/maintenance_task_event_entity.dart';
import 'efficiency_entity.dart';

class MaintenanceTaskEventsResponseEntity {
  final TaskSummaryEntity taskSummaryDay;
  final List<MaintenanceTaskEventEntity> taskFormulary;

  MaintenanceTaskEventsResponseEntity({
    required this.taskSummaryDay,
    required this.taskFormulary,
  });

  // Para compatibilidade com o código existente
  List<MaintenanceTaskEventEntity> get events => taskFormulary;
}
