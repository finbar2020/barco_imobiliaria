import 'package:essentials/essentials.dart';
import 'parent_schedule_event_model.dart';

part 'task_details_model.g.dart';

@JsonSerializable()
class TaskDetailsModel {
  final String id;
  final String? code;
  final String name;
  final String status;
  @JsonKey(name: 'type_task')
  final String typeTask;
  @JsonKey(name: 'local_and_asset')
  final String? localAndAsset;
  @JsonKey(name: 'current_formulary_id')
  final String? currentFormularyId;
  @JsonKey(name: 'current_responsible_id')
  final String? currentResponsibleId;
  @JsonKey(name: 'current_responsible_name')
  final String? currentResponsibleName;
  @JsonKey(name: 'responsible_user_id')
  final String? responsibleId;
  @JsonKey(name: 'responsible_user_name')
  final String? responsibleName;
  @JsonKey(name: 'current_responsible_type')
  final String? currentResponsibleType;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @JsonKey(name: 'current_user')
  final TaskDetailsUserModel? currentUser;
  final TaskDetailsFormularyModel? currentFormulary;
  final TaskDetailsScheduleModel? schedule;
  @JsonKey(name: 'procedure')
  final TaskDetailsProcedureModel? procedure;
  @JsonKey(name: 'all_day')
  final bool? allDay;
  @JsonKey(name: 'is_owner')
  final bool? isOwner;

  // Campos adicionais para payload alternativo
  @JsonKey(name: 'local_or_asset')
  final String? localOrAsset;
  @JsonKey(name: 'schedule_id')
  final String? scheduleId;
  @JsonKey(name: 'task_id')
  final String? taskId;
  @JsonKey(name: 'dt_start')
  final String? dtStart;
  final String? until;
  @JsonKey(name: 'time_start')
  final String? timeStart;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'current_formulary_name')
  final String? currentFormularyName;
  @JsonKey(name: 'local_id')
  final String? localId;
  @JsonKey(name: 'asset_id')
  final String? assetId;
  @JsonKey(name: 'procedure_group')
  final TaskDetailsProcedureGroupModel? procedureGroup;
  @JsonKey(name: 'r_rule')
  final TaskDetailsRRuleModel? rRule;
  @JsonKey(name: 'task')
  final TaskDetailsTaskModel? task;
  @JsonKey(name: 'parent_schedule_event')
  final ParentScheduleEventModel? parentScheduleEvent;
  @JsonKey(name: 'tt_jwt_token')
  final String? ttJwtToken;

  TaskDetailsModel({
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
    this.responsibleId,
    this.responsibleName,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.currentUser,
    this.currentFormulary,
    this.schedule,
    this.procedure,
    this.allDay,
    this.localOrAsset,
    this.scheduleId,
    this.taskId,
    this.dtStart,
    this.until,
    this.timeStart,
    this.timeEnd,
    this.currentFormularyName,
    this.localId,
    this.assetId,
    this.procedureGroup,
    this.rRule,
    this.task,
    this.parentScheduleEvent,
    this.isOwner,
    this.ttJwtToken,
  });

  factory TaskDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsModelToJson(this);
}

@JsonSerializable()
class TaskDetailsUserModel {
  final String id;
  final String name;
  final List<dynamic> references;
  final bool? admin;

  TaskDetailsUserModel({
    required this.id,
    required this.name,
    required this.references,
    this.admin,
  });

  factory TaskDetailsUserModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsUserModelToJson(this);
}

@JsonSerializable()
class TaskDetailsProcedureModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'title_key')
  final String? titleKey;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'url_image')
  final String? urlImage;
  @JsonKey(name: 'procedure_id')
  final String? procedureId;
  @JsonKey(name: 'procedure_group_id')
  final String? procedureGroupId;
  @JsonKey(name: 'procedure_type')
  final String? procedureType;
  @JsonKey(name: 'procedure_group')
  final TaskDetailsProcedureGroupModel? procedureGroup;
  @JsonKey(name: 'first_responsible')
  final TaskDetailsUserModel? firstResponsible;

  TaskDetailsProcedureModel({
    required this.id,
    this.title,
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

  factory TaskDetailsProcedureModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsProcedureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsProcedureModelToJson(this);
}

@JsonSerializable()
class TaskDetailsProcedureGroupModel {
  final String id;
  final String name;
  @JsonKey(name: 'type_task')
  final String? typeTask;

  TaskDetailsProcedureGroupModel({
    required this.id,
    required this.name,
    this.typeTask,
  });

  factory TaskDetailsProcedureGroupModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsProcedureGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsProcedureGroupModelToJson(this);
}

@JsonSerializable()
class TaskDetailsRRuleModel {
  final String frequency;
  @JsonKey(name: 'by_days')
  final List<String>? byDays;

  TaskDetailsRRuleModel({
    required this.frequency,
    this.byDays,
  });

  factory TaskDetailsRRuleModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsRRuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsRRuleModelToJson(this);
}

@JsonSerializable()
class TaskDetailsTaskModel {
  final String id;
  @JsonKey(name: 'current_formulary_id')
  final String? currentFormularyId;
  @JsonKey(name: 'current_responsible_id')
  final String? currentResponsibleId;
  @JsonKey(name: 'current_responsible_name')
  final String? currentResponsibleName;
  @JsonKey(name: 'current_responsible_type')
  final String? currentResponsibleType;
  final TaskDetailsChannelModel? channel;
  @JsonKey(name: 'current_formulary')
  final TaskDetailsFormularyModel? currentFormulary;
  @JsonKey(name: 'current_user')
  final TaskDetailsUserModel? currentUser;

  TaskDetailsTaskModel({
    required this.id,
    this.currentFormularyId,
    this.currentResponsibleId,
    this.currentResponsibleName,
    this.currentResponsibleType,
    this.channel,
    this.currentFormulary,
    this.currentUser,
  });

  factory TaskDetailsTaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsTaskModelToJson(this);
}

@JsonSerializable()
class TaskDetailsFormularyModel {
  final String id;
  final String name;
  final int? position;
  final bool? enabled;

  TaskDetailsFormularyModel({
    required this.id,
    required this.name,
    this.position,
    this.enabled,
  });

  factory TaskDetailsFormularyModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsFormularyModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsFormularyModelToJson(this);
}

@JsonSerializable()
class TaskDetailsScheduleModel {
  final String id;
  final String name;
  final String? repeat;
  final String? dtstart;
  @JsonKey(name: 'all_day')
  final bool? allDay;
  @JsonKey(name: 'asset_id')
  final String? assetId;
  @JsonKey(name: 'asset_maintenance_type')
  final String? assetMaintenanceType;
  @JsonKey(name: 'contract_id')
  final String? contractId;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final bool? enabled;
  @JsonKey(name: 'local_id')
  final String? localId;
  @JsonKey(name: 'partner_id')
  final String? partnerId;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  @JsonKey(name: 'time_start')
  final String? timeStart;
  final String? until;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'workflow_id')
  final String? workflowId;
  final String? rrule;
  @JsonKey(name: 'schedule_id')
  final String? scheduleId;
  final String? recurrency;
  @JsonKey(name: 'procedure_id')
  final String? procedureId;
  @JsonKey(name: 'procedure_group_id')
  final String? procedureGroupId;
  final String? status;
  @JsonKey(name: 'procedure_group')
  final TaskDetailsProcedureGroupModel? procedureGroup;

  TaskDetailsScheduleModel({
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

  factory TaskDetailsScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsScheduleModelToJson(this);
}

@JsonSerializable()
class TaskDetailsChannelModel {
  final String id;
  @JsonKey(name: 'type_task')
  final String typeTask;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String task;
  @JsonKey(name: 'last_message')
  final String? lastMessage;

  TaskDetailsChannelModel({
    required this.id,
    required this.typeTask,
    required this.status,
    required this.createdAt,
    required this.task,
    this.lastMessage,
  });

  factory TaskDetailsChannelModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailsChannelModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDetailsChannelModelToJson(this);
}

@JsonSerializable()
class ParentScheduleEventModel {
  final String id;
  final String name;

  ParentScheduleEventModel({
    required this.id,
    required this.name,
  });

  factory ParentScheduleEventModel.fromJson(Map<String, dynamic> json) =>
      _$ParentScheduleEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentScheduleEventModelToJson(this);
}
