import 'package:json_annotation/json_annotation.dart';

import '../../../../shared_features.dart';

part 'ghost_notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GhostNotificationModel {
  String? id;
  String? token;
  String? appType;
  String? recivedDate;
  String? appVersion;
  String? deviceName;
  String? logedUserCpf;
  String? logedUserId;
  dynamic customData;
  String? type;

  GhostNotificationModel({
    this.id,
    this.token,
    this.appType,
    this.recivedDate,
    this.appVersion,
    this.deviceName,
    this.logedUserCpf,
    this.logedUserId,
    this.customData,
    this.type,
  });

  factory GhostNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$GhostNotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$GhostNotificationModelToJson(this);

  static GhostNotificationModel? fromEntity(GhostNotificationEntity? entity) =>
      entity == null
          ? null
          : (GhostNotificationModel(
              id: entity.id,
              token: entity.token,
              appType: entity.appType,
              recivedDate: entity.recivedDate,
              appVersion: entity.appVersion,
              deviceName: entity.deviceName,
              logedUserCpf: entity.logedUserCpf,
              logedUserId: entity.logedUserId,
              customData: entity.customData,
            ));

  GhostNotificationEntity toEntity() => GhostNotificationEntity(
        id: this.id,
        token: this.token,
        appType: this.appType,
        recivedDate: this.recivedDate,
        appVersion: this.appVersion,
        deviceName: this.deviceName,
        logedUserCpf: this.logedUserCpf,
        logedUserId: this.logedUserId,
        customData: this.customData,
      );
}
