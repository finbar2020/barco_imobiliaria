import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/reports_book/domain/entity/content_send.dart';

part 'content_send_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ContentSendModel {
  String? idReport;
  String? content;

  ContentSendModel({
    this.idReport,
    this.content,
  });

  factory ContentSendModel.fromJson(Map<String, dynamic> json) =>
      _$ContentSendModelFromJson(json);
  Map<String, dynamic> toJson() => _$ContentSendModelToJson(this);

  static ContentSendModel? fromEntity(ContentSend? entity) => entity == null
      ? null
      : (ContentSendModel()
        ..idReport = entity.idReport
        ..content = entity.content);

  ContentSend toEntity() => ContentSend()
    ..idReport = this.idReport
    ..content = this.content;
}
