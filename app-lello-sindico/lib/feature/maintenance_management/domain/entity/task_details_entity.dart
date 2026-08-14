import 'parent_schedule_event_entity.dart';

class TaskDetailsEntity {
  final String id;
  final String? code;
  final String name;
  final String status;
  final String typeTask;
  final String? localAndAsset;
  final String? currentFormularyId;
  final String? currentResponsibleId;
  final String? currentResponsibleName;
  final String? currentResponsibleType;
  final String? responsibleId;
  final String? responsibleName;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final TaskDetailsUserEntity? currentUser;
  final TaskDetailsFormularyEntity? currentFormulary;
  final TaskDetailsScheduleEntity? schedule;
  final TaskDetailsProcedureEntity? procedure;
  final bool allDay;
  final String? localOrAsset;
  final String? scheduleId;
  final String? taskId;
  final String? dtStart;
  final String? until;
  final String? timeStart;
  final String? timeEnd;
  final String? responsibleUserName;
  final String? responsibleUserId;
  final String? currentFormularyName;
  final String? localId;
  final String? assetId;
  final TaskDetailsProcedureGroupEntity? procedureGroup;
  final TaskDetailsRRuleEntity? rRule;
  final TaskDetailsTaskEntity? task;
  final ParentScheduleEventEntity? parentScheduleEvent;
  final bool? isOwner;
  final String? ttJwtToken;

  TaskDetailsEntity({
    required this.id,
    this.code,
    required this.name,
    required this.status,
    required this.typeTask,
    this.localAndAsset,
    this.currentFormularyId,
    this.currentResponsibleId,
    this.currentResponsibleName,
    this.currentResponsibleType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.currentUser,
    this.currentFormulary,
    this.schedule,
    this.procedure,
    required this.allDay,
    this.localOrAsset,
    this.scheduleId,
    this.taskId,
    this.dtStart,
    this.until,
    this.timeStart,
    this.timeEnd,
    this.responsibleUserName,
    this.responsibleUserId,
    this.currentFormularyName,
    this.localId,
    this.assetId,
    this.procedureGroup,
    this.rRule,
    this.task,
    this.parentScheduleEvent,
    this.isOwner,
    this.responsibleId,
    this.responsibleName,
    this.ttJwtToken,
  });

  // Conveniências de retrocompatibilidade
  String get title => name;

  TaskDetailsUserEntity? get effectiveCurrentUser =>
      currentUser ?? task?.currentUser;
}

class TaskDetailsUserEntity {
  final String id;
  final String name;
  final List<dynamic> references;
  final bool? admin;

  TaskDetailsUserEntity({
    required this.id,
    required this.name,
    required this.references,
    this.admin,
  });
}

class TaskDetailsFormularyEntity {
  final String id;
  final String name;
  final int? position;
  final bool? enabled;

  TaskDetailsFormularyEntity({
    required this.id,
    required this.name,
    this.position,
    this.enabled,
  });
}

class TaskDetailsScheduleEntity {
  final String id;
  final String name;
  final String? repeat;
  final String? dtstart;
  final bool? allDay;
  final String? assetId;
  final String? assetMaintenanceType;
  final String? contractId;
  final String? createdAt;
  final String? deletedAt;
  final bool? enabled;
  final String? localId;
  final String? partnerId;
  final String? timeEnd;
  final String? timeStart;
  final String? until;
  final String? updatedAt;
  final String? workflowId;
  final String? rrule;
  final String? scheduleId;
  final String? recurrency;
  final String? procedureId;
  final String? procedureGroupId;
  final String? status;
  final TaskDetailsProcedureGroupEntity? procedureGroup;

  TaskDetailsScheduleEntity({
    required this.id,
    required this.name,
    this.repeat,
    this.dtstart,
    this.allDay,
    this.assetId,
    this.assetMaintenanceType,
    this.contractId,
    this.createdAt,
    this.deletedAt,
    this.enabled,
    this.localId,
    this.partnerId,
    this.timeEnd,
    this.timeStart,
    this.until,
    this.updatedAt,
    this.workflowId,
    this.rrule,
    this.scheduleId,
    this.recurrency,
    this.procedureId,
    this.procedureGroupId,
    this.status,
    this.procedureGroup,
  });
}

class TaskDetailsProcedureEntity {
  final String id;
  final String title;
  final String? name;
  final String? titleKey;
  final String? description;
  final String? urlImage;
  final String? procedureId;
  final String? procedureGroupId;
  final String? procedureType;
  final TaskDetailsProcedureGroupEntity? procedureGroup;
  final TaskDetailsUserEntity? firstResponsible;

  TaskDetailsProcedureEntity({
    required this.id,
    required this.title,
    this.titleKey,
    this.name,
    this.description,
    this.urlImage,
    this.procedureId,
    this.procedureGroupId,
    this.procedureType,
    this.procedureGroup,
    this.firstResponsible,
  });
}

class TaskDetailsProcedureGroupEntity {
  final String id;
  final String name;
  final String? typeTask;

  TaskDetailsProcedureGroupEntity({
    required this.id,
    required this.name,
    this.typeTask,
  });
}

class TaskDetailsRRuleEntity {
  final String frequency;
  final List<String>? byDays;

  TaskDetailsRRuleEntity({
    required this.frequency,
    this.byDays,
  });

  bool get isWeekly => frequency.toUpperCase() == 'WEEKLY';
  bool get isDaily => frequency.toUpperCase() == 'DAILY';
}

class TaskDetailsTaskEntity {
  final String id;
  final String? currentFormularyId;
  final String? currentResponsibleId;
  final String? currentResponsibleName;
  final String? currentResponsibleType;
  final TaskDetailsChannelEntity? channel;
  final TaskDetailsFormularyEntity? currentFormulary;
  final TaskDetailsUserEntity? currentUser;

  TaskDetailsTaskEntity({
    required this.id,
    this.currentFormularyId,
    this.currentResponsibleId,
    this.currentResponsibleName,
    this.currentResponsibleType,
    this.channel,
    this.currentFormulary,
    this.currentUser,
  });
}

class TaskDetailsChannelEntity {
  final String id;
  final String typeTask;
  final String status;
  final String createdAt;
  final String task;
  final String? lastMessage;

  TaskDetailsChannelEntity({
    required this.id,
    required this.typeTask,
    required this.status,
    required this.createdAt,
    required this.task,
    this.lastMessage,
  });
}

class ParentScheduleEventEntity {
  final String id;
  final String name;

  ParentScheduleEventEntity({
    required this.id,
    required this.name,
  });
}
