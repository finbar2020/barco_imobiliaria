// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDetailsModel _$TaskDetailsModelFromJson(Map<String, dynamic> json) =>
    TaskDetailsModel(
      id: json['id'] as String,
      code: json['code'] as String?,
      name: json['name'] as String,
      status: json['status'] as String,
      typeTask: json['type_task'] as String,
      localAndAsset: json['local_and_asset'] as String?,
      currentFormularyId: json['current_formulary_id'] as String?,
      currentResponsibleId: json['current_responsible_id'] as String?,
      currentResponsibleName: json['current_responsible_name'] as String?,
      currentResponsibleType: json['current_responsible_type'] as String?,
      responsibleId: json['responsible_user_id'] as String?,
      responsibleName: json['responsible_user_name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      currentUser: json['current_user'] == null
          ? null
          : TaskDetailsUserModel.fromJson(
              json['current_user'] as Map<String, dynamic>),
      currentFormulary: json['currentFormulary'] == null
          ? null
          : TaskDetailsFormularyModel.fromJson(
              json['currentFormulary'] as Map<String, dynamic>),
      schedule: json['schedule'] == null
          ? null
          : TaskDetailsScheduleModel.fromJson(
              json['schedule'] as Map<String, dynamic>),
      procedure: json['procedure'] == null
          ? null
          : TaskDetailsProcedureModel.fromJson(
              json['procedure'] as Map<String, dynamic>),
      allDay: json['all_day'] as bool?,
      localOrAsset: json['local_or_asset'] as String?,
      scheduleId: json['schedule_id'] as String?,
      taskId: json['task_id'] as String?,
      dtStart: json['dt_start'] as String?,
      until: json['until'] as String?,
      timeStart: json['time_start'] as String?,
      timeEnd: json['time_end'] as String?,
      currentFormularyName: json['current_formulary_name'] as String?,
      localId: json['local_id'] as String?,
      assetId: json['asset_id'] as String?,
      procedureGroup: json['procedure_group'] == null
          ? null
          : TaskDetailsProcedureGroupModel.fromJson(
              json['procedure_group'] as Map<String, dynamic>),
      rRule: json['r_rule'] == null
          ? null
          : TaskDetailsRRuleModel.fromJson(
              json['r_rule'] as Map<String, dynamic>),
      task: json['task'] == null
          ? null
          : TaskDetailsTaskModel.fromJson(json['task'] as Map<String, dynamic>),
      parentScheduleEvent: json['parent_schedule_event'] == null
          ? null
          : ParentScheduleEventModel.fromJson(
              json['parent_schedule_event'] as Map<String, dynamic>),
      isOwner: json['is_owner'] as bool?,
      ttJwtToken: json['tt_jwt_token'] as String?,
    );

Map<String, dynamic> _$TaskDetailsModelToJson(TaskDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'status': instance.status,
      'type_task': instance.typeTask,
      'local_and_asset': instance.localAndAsset,
      'current_formulary_id': instance.currentFormularyId,
      'current_responsible_id': instance.currentResponsibleId,
      'current_responsible_name': instance.currentResponsibleName,
      'responsible_user_id': instance.responsibleId,
      'responsible_user_name': instance.responsibleName,
      'current_responsible_type': instance.currentResponsibleType,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'current_user': instance.currentUser,
      'currentFormulary': instance.currentFormulary,
      'schedule': instance.schedule,
      'procedure': instance.procedure,
      'all_day': instance.allDay,
      'is_owner': instance.isOwner,
      'local_or_asset': instance.localOrAsset,
      'schedule_id': instance.scheduleId,
      'task_id': instance.taskId,
      'dt_start': instance.dtStart,
      'until': instance.until,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'current_formulary_name': instance.currentFormularyName,
      'local_id': instance.localId,
      'asset_id': instance.assetId,
      'procedure_group': instance.procedureGroup,
      'r_rule': instance.rRule,
      'task': instance.task,
      'parent_schedule_event': instance.parentScheduleEvent,
      'tt_jwt_token': instance.ttJwtToken,
    };

TaskDetailsUserModel _$TaskDetailsUserModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      references: json['references'] as List<dynamic>,
      admin: json['admin'] as bool?,
    );

Map<String, dynamic> _$TaskDetailsUserModelToJson(
        TaskDetailsUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'references': instance.references,
      'admin': instance.admin,
    };

TaskDetailsProcedureModel _$TaskDetailsProcedureModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsProcedureModel(
      id: json['id'] as String,
      title: json['title'] as String?,
      titleKey: json['title_key'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      urlImage: json['url_image'] as String?,
      procedureId: json['procedure_id'] as String?,
      procedureGroupId: json['procedure_group_id'] as String?,
      procedureType: json['procedure_type'] as String?,
      procedureGroup: json['procedure_group'] == null
          ? null
          : TaskDetailsProcedureGroupModel.fromJson(
              json['procedure_group'] as Map<String, dynamic>),
      firstResponsible: json['first_responsible'] == null
          ? null
          : TaskDetailsUserModel.fromJson(
              json['first_responsible'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskDetailsProcedureModelToJson(
        TaskDetailsProcedureModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'title_key': instance.titleKey,
      'description': instance.description,
      'url_image': instance.urlImage,
      'procedure_id': instance.procedureId,
      'procedure_group_id': instance.procedureGroupId,
      'procedure_type': instance.procedureType,
      'procedure_group': instance.procedureGroup,
      'first_responsible': instance.firstResponsible,
    };

TaskDetailsProcedureGroupModel _$TaskDetailsProcedureGroupModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsProcedureGroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      typeTask: json['type_task'] as String?,
    );

Map<String, dynamic> _$TaskDetailsProcedureGroupModelToJson(
        TaskDetailsProcedureGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type_task': instance.typeTask,
    };

TaskDetailsRRuleModel _$TaskDetailsRRuleModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsRRuleModel(
      frequency: json['frequency'] as String,
      byDays:
          (json['by_days'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TaskDetailsRRuleModelToJson(
        TaskDetailsRRuleModel instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'by_days': instance.byDays,
    };

TaskDetailsTaskModel _$TaskDetailsTaskModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsTaskModel(
      id: json['id'] as String,
      currentFormularyId: json['current_formulary_id'] as String?,
      currentResponsibleId: json['current_responsible_id'] as String?,
      currentResponsibleName: json['current_responsible_name'] as String?,
      currentResponsibleType: json['current_responsible_type'] as String?,
      channel: json['channel'] == null
          ? null
          : TaskDetailsChannelModel.fromJson(
              json['channel'] as Map<String, dynamic>),
      currentFormulary: json['current_formulary'] == null
          ? null
          : TaskDetailsFormularyModel.fromJson(
              json['current_formulary'] as Map<String, dynamic>),
      currentUser: json['current_user'] == null
          ? null
          : TaskDetailsUserModel.fromJson(
              json['current_user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskDetailsTaskModelToJson(
        TaskDetailsTaskModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'current_formulary_id': instance.currentFormularyId,
      'current_responsible_id': instance.currentResponsibleId,
      'current_responsible_name': instance.currentResponsibleName,
      'current_responsible_type': instance.currentResponsibleType,
      'channel': instance.channel,
      'current_formulary': instance.currentFormulary,
      'current_user': instance.currentUser,
    };

TaskDetailsFormularyModel _$TaskDetailsFormularyModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsFormularyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      position: (json['position'] as num?)?.toInt(),
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$TaskDetailsFormularyModelToJson(
        TaskDetailsFormularyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'enabled': instance.enabled,
    };

TaskDetailsScheduleModel _$TaskDetailsScheduleModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsScheduleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      repeat: json['repeat'] as String?,
      dtstart: json['dtstart'] as String?,
      allDay: json['all_day'] as bool?,
      assetId: json['asset_id'] as String?,
      assetMaintenanceType: json['asset_maintenance_type'] as String?,
      contractId: json['contract_id'] as String?,
      createdAt: json['created_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      enabled: json['enabled'] as bool?,
      localId: json['local_id'] as String?,
      partnerId: json['partner_id'] as String?,
      timeEnd: json['time_end'] as String?,
      timeStart: json['time_start'] as String?,
      until: json['until'] as String?,
      updatedAt: json['updated_at'] as String?,
      workflowId: json['workflow_id'] as String?,
      rrule: json['rrule'] as String?,
      scheduleId: json['schedule_id'] as String?,
      recurrency: json['recurrency'] as String?,
      procedureId: json['procedure_id'] as String?,
      procedureGroupId: json['procedure_group_id'] as String?,
      status: json['status'] as String?,
      procedureGroup: json['procedure_group'] == null
          ? null
          : TaskDetailsProcedureGroupModel.fromJson(
              json['procedure_group'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskDetailsScheduleModelToJson(
        TaskDetailsScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'repeat': instance.repeat,
      'dtstart': instance.dtstart,
      'all_day': instance.allDay,
      'asset_id': instance.assetId,
      'asset_maintenance_type': instance.assetMaintenanceType,
      'contract_id': instance.contractId,
      'created_at': instance.createdAt,
      'deleted_at': instance.deletedAt,
      'enabled': instance.enabled,
      'local_id': instance.localId,
      'partner_id': instance.partnerId,
      'time_end': instance.timeEnd,
      'time_start': instance.timeStart,
      'until': instance.until,
      'updated_at': instance.updatedAt,
      'workflow_id': instance.workflowId,
      'rrule': instance.rrule,
      'schedule_id': instance.scheduleId,
      'recurrency': instance.recurrency,
      'procedure_id': instance.procedureId,
      'procedure_group_id': instance.procedureGroupId,
      'status': instance.status,
      'procedure_group': instance.procedureGroup,
    };

TaskDetailsChannelModel _$TaskDetailsChannelModelFromJson(
        Map<String, dynamic> json) =>
    TaskDetailsChannelModel(
      id: json['id'] as String,
      typeTask: json['type_task'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      task: json['task'] as String,
      lastMessage: json['last_message'] as String?,
    );

Map<String, dynamic> _$TaskDetailsChannelModelToJson(
        TaskDetailsChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type_task': instance.typeTask,
      'status': instance.status,
      'created_at': instance.createdAt,
      'task': instance.task,
      'last_message': instance.lastMessage,
    };

ParentScheduleEventModel _$ParentScheduleEventModelFromJson(
        Map<String, dynamic> json) =>
    ParentScheduleEventModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ParentScheduleEventModelToJson(
        ParentScheduleEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
