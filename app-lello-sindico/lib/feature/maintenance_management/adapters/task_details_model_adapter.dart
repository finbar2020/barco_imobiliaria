import '../data/model/task_details_model.dart';
import '../domain/entity/task_details_entity.dart';

class TaskDetailsModelAdapter {
  static TaskDetailsEntity toEntity(TaskDetailsModel model) {
    return TaskDetailsEntity(
      id: model.id,
      code: model.code,
      name: model.name,
      status: model.status,
      typeTask: model.typeTask,
      localAndAsset: model.localAndAsset,
      currentFormularyId: model.currentFormularyId,
      currentResponsibleId: model.currentResponsibleId,
      currentResponsibleName: model.currentResponsibleName,
      currentResponsibleType: model.currentResponsibleType,
      createdAt: model.createdAt,
      responsibleId: model.responsibleId,
      responsibleName: model.responsibleName,
      isOwner: model.isOwner,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
      currentUser: model.currentUser != null
          ? TaskDetailsUserEntity(
              id: model.currentUser!.id,
              name: model.currentUser!.name,
              references: model.currentUser!.references,
              admin: model.currentUser!.admin,
            )
          : null,
      currentFormulary: model.currentFormulary != null
          ? TaskDetailsFormularyEntity(
              id: model.currentFormulary!.id,
              name: model.currentFormulary!.name,
              position: model.currentFormulary!.position,
              enabled: model.currentFormulary!.enabled,
            )
          : null,
      schedule: _mapSchedule(model.schedule),
      procedure: _mapProcedure(model.procedure),
      allDay: model.allDay ?? false,
      localOrAsset: model.localOrAsset,
      scheduleId: model.scheduleId,
      taskId: model.taskId,
      dtStart: model.dtStart,
      until: model.until,
      timeStart: model.timeStart,
      timeEnd: model.timeEnd,
      localId: model.localId,
      assetId: model.assetId,
      procedureGroup: _mapProcedureGroup(model.procedureGroup),
      rRule: model.rRule != null
          ? TaskDetailsRRuleEntity(
              frequency: model.rRule!.frequency,
              byDays: model.rRule!.byDays,
            )
          : null,
      task: _mapTask(model.task),
      parentScheduleEvent: model.parentScheduleEvent != null
          ? ParentScheduleEventEntity(
              id: model.parentScheduleEvent!.id,
              name: model.parentScheduleEvent!.name,
            )
          : null,
      ttJwtToken: model.ttJwtToken,
    );
  }

  static TaskDetailsProcedureEntity? _mapProcedure(
      TaskDetailsProcedureModel? procedure) {
    if (procedure == null) {
      return null;
    }

    return TaskDetailsProcedureEntity(
      id: procedure.id,
      title: procedure.title ?? '',
      name: procedure.name ?? '',
      titleKey: procedure.titleKey ?? '',
      description: procedure.description ?? '',
      urlImage: procedure.urlImage ?? '',
      procedureId: procedure.procedureId ?? '',
      procedureGroupId: procedure.procedureGroupId ?? '',
      procedureType: procedure.procedureType ?? '',
      procedureGroup: procedure.procedureGroup != null
          ? TaskDetailsProcedureGroupEntity(
              id: procedure.procedureGroup!.id,
              name: procedure.procedureGroup!.name,
              typeTask: procedure.procedureGroup!.typeTask,
            )
          : null,
      firstResponsible: procedure.firstResponsible != null
          ? TaskDetailsUserEntity(
              id: procedure.firstResponsible!.id,
              name: procedure.firstResponsible!.name,
              references: procedure.firstResponsible!.references,
              admin: procedure.firstResponsible!.admin,
            )
          : null,
    );
  }

  static TaskDetailsProcedureGroupEntity? _mapProcedureGroup(
      TaskDetailsProcedureGroupModel? group) {
    if (group == null) {
      return null;
    }

    return TaskDetailsProcedureGroupEntity(
      id: group.id,
      name: group.name,
      typeTask: group.typeTask,
    );
  }

  static TaskDetailsTaskEntity? _mapTask(TaskDetailsTaskModel? task) {
    if (task == null) {
      return null;
    }

    return TaskDetailsTaskEntity(
      id: task.id,
      currentFormularyId: task.currentFormularyId,
      currentResponsibleId: task.currentResponsibleId,
      currentResponsibleName: task.currentResponsibleName,
      currentResponsibleType: task.currentResponsibleType,
      channel: task.channel != null
          ? TaskDetailsChannelEntity(
              id: task.channel!.id,
              typeTask: task.channel!.typeTask,
              status: task.channel!.status,
              createdAt: task.channel!.createdAt,
              task: task.channel!.task,
              lastMessage: task.channel!.lastMessage,
            )
          : null,
      currentFormulary: task.currentFormulary != null
          ? TaskDetailsFormularyEntity(
              id: task.currentFormulary!.id,
              name: task.currentFormulary!.name,
              position: task.currentFormulary!.position,
              enabled: task.currentFormulary!.enabled,
            )
          : null,
      currentUser: task.currentUser != null
          ? TaskDetailsUserEntity(
              id: task.currentUser!.id,
              name: task.currentUser!.name,
              references: task.currentUser!.references,
              admin: task.currentUser!.admin,
            )
          : null,
    );
  }

  static TaskDetailsScheduleEntity? _mapSchedule(
      TaskDetailsScheduleModel? schedule) {
    if (schedule == null) {
      return null;
    }

    return TaskDetailsScheduleEntity(
      id: schedule.id,
      name: schedule.name,
      repeat: schedule.repeat,
      dtstart: schedule.dtstart,
      allDay: schedule.allDay,
      assetId: schedule.assetId,
      assetMaintenanceType: schedule.assetMaintenanceType,
      contractId: schedule.contractId,
      createdAt: schedule.createdAt,
      deletedAt: schedule.deletedAt,
      enabled: schedule.enabled,
      localId: schedule.localId,
      partnerId: schedule.partnerId,
      timeEnd: schedule.timeEnd,
      timeStart: schedule.timeStart,
      until: schedule.until,
      updatedAt: schedule.updatedAt,
      workflowId: schedule.workflowId,
      rrule: schedule.rrule,
      scheduleId: schedule.scheduleId,
      recurrency: schedule.recurrency,
      procedureId: schedule.procedureId,
      procedureGroupId: schedule.procedureGroupId,
      status: schedule.status,
      procedureGroup: schedule.procedureGroup != null
          ? TaskDetailsProcedureGroupEntity(
              id: schedule.procedureGroup!.id,
              name: schedule.procedureGroup!.name,
              typeTask: schedule.procedureGroup!.typeTask,
            )
          : null,
    );
  }
}
