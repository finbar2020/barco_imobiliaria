import 'package:json_annotation/json_annotation.dart';

import '../../../../shared_features.dart';

part 'notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationModel {
  String? id;
  DateTime? date;
  String? title;
  String? message;
  DateTime? visualizedAt;
  String? status;
  String? reference;
  String? identifier;
  String? module;
  String? type;
  bool? markRead;
  bool? inApp;
  String? typeRedirect;
  String? redirectPath;
  String? redirectId;
  String? callback;
  String? hash;
  String? bigMessage;
  String? senderId;
  String? uuidGroup;

  NotificationModel({
    this.id,
    this.date,
    this.title,
    this.message,
    this.visualizedAt,
    this.status,
    this.reference,
    this.identifier,
    this.module,
    this.type,
    this.markRead,
    this.inApp,
    this.typeRedirect,
    this.redirectPath,
    this.redirectId,
    this.callback,
    this.hash,
    this.bigMessage,
    this.senderId,
    this.uuidGroup,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    var result = _$NotificationModelFromJson(json);
    if (json.containsKey("redirectId")) {
      result.redirectId = json["redirectId"];
    }
    if (json.containsKey("redirectPath")) {
      result.redirectPath = json["redirectPath"];
    }
    if (json.containsKey("path")) {
      result.redirectPath = json["path"];
    }
    if (json.containsKey("visualizedAt")) {
      result.visualizedAt = json['visualizedAt'] == null
          ? null
          : DateTime.parse(json['visualizedAt'] as String);
    }
    if (json.containsKey("markRead")) {
      result.markRead = json["markRead"].toString() == "true";
    }
    if (json.containsKey("inApp")) {
      result.inApp = json["inApp"].toString() == "true";
    }
    if (json.containsKey("typeRedirect")) {
      result.typeRedirect = json["typeRedirect"];
    }
    if (json.containsKey("bigMessage")) {
      result.bigMessage = json["bigMessage"];
    }
    if (json.containsKey("senderId")) {
      result.senderId = json["senderId"];
    }
    if (json.containsKey("uuid_group")) {
      result.uuidGroup = json["uuid_group"];
    }
    if (json.containsKey("uuidGroup")) {
      result.uuidGroup = json["uuidGroup"];
    }
    return result;
  }

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  static NotificationModel? fromEntity(SingleNotification? entity) =>
      entity == null
          ? null
          : (NotificationModel()
            ..id = entity.id
            ..date = entity.date
            ..title = entity.title
            ..message = entity.message
            ..visualizedAt = entity.visualizedAt
            ..status = entity.status
            ..reference = entity.reference
            ..identifier = entity.identifier
            ..module = entity.module
            ..type = entity.type
            ..markRead = entity.markRead
            ..inApp = entity.inApp
            ..typeRedirect = entity.typeRedirect
            ..redirectPath = entity.redirectPath
            ..redirectId = entity.redirectId
            ..hash = entity.hash
            ..bigMessage = entity.bigMessage
            ..callback = entity.callback
            ..senderId = entity.senderId
            ..uuidGroup = entity.uuidGroup);

  SingleNotification toEntity({required int page}) => SingleNotification()
    ..id = this.id
    ..date = this.date
    ..title = this.title
    ..message = this.message
    ..visualizedAt = this.visualizedAt
    ..status = this.status
    ..reference = this.reference
    ..identifier = this.identifier
    ..module = this.module
    ..type = this.type
    ..markRead = this.markRead
    ..inApp = this.inApp
    ..typeRedirect = this.typeRedirect
    ..redirectPath = this.redirectPath
    ..redirectId = this.redirectId
    ..callback = this.callback
    ..hash = this.hash
    ..bigMessage = this.bigMessage
    ..page = page
    ..senderId = senderId
    ..uuidGroup = uuidGroup;

  bool get canRedirect => redirectPath?.isNotEmpty == true;
}
