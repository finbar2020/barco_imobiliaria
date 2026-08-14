import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/dashboard/domain/entity/read_notification.dart';

part 'read_notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReadNotificationModel {
  bool? lido;
  String? module;

  ReadNotificationModel();

  factory ReadNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$ReadNotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReadNotificationModelToJson(this);

  static ReadNotificationModel? fromEntity(ReadNotification? entity) =>
      entity == null
          ? null
          : (ReadNotificationModel()
            ..lido = entity.lido
            ..module = entity.module);

  ReadNotification toEntity() => ReadNotification()
    ..lido = this.lido
    ..module = this.module;
}
