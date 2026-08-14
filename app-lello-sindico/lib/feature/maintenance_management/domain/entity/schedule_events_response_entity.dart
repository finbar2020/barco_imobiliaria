import 'schedule_event_task_entity.dart';
import 'efficiency_entity.dart';

/// Resposta da API de schedule events com dados de tarefas agendadas
class ScheduleEventsResponseEntity {
  /// Indica se a operação foi bem-sucedida
  final bool success;

  /// Mensagem de retorno da operação
  final String message;

  /// Resumo das tarefas do dia
  final TaskSummaryEntity? taskSummaryDay;

  /// Lista de tarefas/eventos agendados
  final List<ScheduleEventTaskEntity> taskFormulary;

  /// Código de erro (null se sucesso)
  final String? errorCode;

  /// Código de status legacy para compatibilidade
  final int legacyStatusCode;

  const ScheduleEventsResponseEntity({
    required this.success,
    required this.message,
    this.taskSummaryDay,
    required this.taskFormulary,
    this.errorCode,
    required this.legacyStatusCode,
  });

  factory ScheduleEventsResponseEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    TaskSummaryEntity? taskSummary;
    if (data['taskSummaryDay'] != null) {
      final summaryData = data['taskSummaryDay'] as Map<String, dynamic>;
      taskSummary = TaskSummaryEntity(
        total: summaryData['total'] as int,
        done: summaryData['done'] as int,
        notStarted: summaryData['notStarted'] as int,
        draft: summaryData['draft'] as int,
        pending: summaryData['pending'] as int? ?? 0,
      );
    }

    return ScheduleEventsResponseEntity(
      success: json['success'] as bool,
      message: json['message'] as String,
      taskSummaryDay: taskSummary,
      taskFormulary: (data['taskFormulary'] as List<dynamic>?)
              ?.map((e) =>
                  ScheduleEventTaskEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      errorCode: json['errorCode'] as String?,
      legacyStatusCode: json['legacyStatusCode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'taskSummaryDay': taskSummaryDay != null ? {
          'total': taskSummaryDay!.total,
          'done': taskSummaryDay!.done,
          'notStarted': taskSummaryDay!.notStarted,
          'draft': taskSummaryDay!.draft,
          'pending': taskSummaryDay!.pending,
        } : null,
        'taskFormulary': taskFormulary.map((e) => e.toJson()).toList(),
      },
      'errorCode': errorCode,
      'legacyStatusCode': legacyStatusCode,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleEventsResponseEntity &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          taskSummaryDay == other.taskSummaryDay &&
          taskFormulary == other.taskFormulary &&
          errorCode == other.errorCode &&
          legacyStatusCode == other.legacyStatusCode;

  @override
  int get hashCode =>
      success.hashCode ^
      message.hashCode ^
      taskSummaryDay.hashCode ^
      taskFormulary.hashCode ^
      errorCode.hashCode ^
      legacyStatusCode.hashCode;

  @override
  String toString() {
    return 'ScheduleEventsResponseEntity(success: $success, message: $message, tasks: ${taskFormulary.length})';
  }
}
