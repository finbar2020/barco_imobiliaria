import 'package:essentials/enum/enum_serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';

part 'notifications_preferences_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationsPreferencesModel {
  String? id_pendency_rule_reference;
  String? id_pendency_rule;
  int reference;
  int? quarantine_days;
  String? last_execution;
  bool active;
  String module;
  String config_type;
  String alt_text;
  List<String> receive_type;

  NotificationsPreferencesModel({
    this.id_pendency_rule_reference,
    this.id_pendency_rule,
    required this.reference,
    this.quarantine_days,
    this.last_execution,
    required this.active,
    required this.module,
    required this.config_type,
    required this.alt_text,
    required this.receive_type,
  });

  factory NotificationsPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPreferencesModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationsPreferencesModelToJson(this);

  static NotificationsPreferencesModel fromEntity(
          NotificationsPreferences entity) =>
      (NotificationsPreferencesModel(
        id_pendency_rule_reference: entity.idPendencyRuleReference,
        id_pendency_rule: entity.idPendencyRule,
        reference: entity.reference,
        quarantine_days: entity.quarentineDays,
        last_execution: entity.lastExecution,
        active: entity.active,
        module: entity.module,
        config_type: entity.configType,
        alt_text: entity.altText,
        receive_type: entity.listType
            .map((e) => enumToString(e))
            .whereType<String>()
            .toList(),
      ));

  NotificationsPreferences toEntity() => NotificationsPreferences(
        idPendencyRuleReference: id_pendency_rule_reference,
        idPendencyRule: id_pendency_rule,
        reference: reference,
        quarentineDays: quarantine_days,
        lastExecution: last_execution,
        active: active,
        module: module,
        configType: config_type,
        altText: alt_text,
        listType: receive_type
            .map((e) => stringToEnum(NotificationsPreferencesType.values, e))
            .whereType<NotificationsPreferencesType>()
            .toList(),
      );
}
