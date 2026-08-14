import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';

part 'preferences_notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PreferencesNotificationModel {
  bool? active;
  String? module;

  PreferencesNotificationModel({
    this.active,
    this.module,
  });

  factory PreferencesNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesNotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesNotificationModelToJson(this);

  static PreferencesNotificationModel fromEntity(
          PreferencesNotificationEntity entity) =>
      (PreferencesNotificationModel()
        ..active = entity.active
        ..module = entity.module);

  PreferencesNotificationEntity toEntity() => PreferencesNotificationEntity()
    ..active = this.active
    ..module = this.module;
}
