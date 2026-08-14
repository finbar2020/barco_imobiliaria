import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';

part 'report_contents_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportContentsModel {
  String? id;
  int? numReport;
  int? typeUser;
  String? content;
  String? attachment;
  String? attachmentType;
  DateTime? dateContent;

  ReportContentsModel({
    this.id,
    this.numReport,
    this.typeUser,
    this.content,
    this.attachment,
    this.attachmentType,
    this.dateContent,
  });

  factory ReportContentsModel.fromJson(Map<String, dynamic> json) =>
      _$ReportContentsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportContentsModelToJson(this);

  static ReportContentsModel? fromEntity(ReportContents? entity) =>
      entity == null
          ? null
          : (ReportContentsModel()
            ..id = entity.id
            ..numReport = entity.numReport
            ..typeUser = entity.typeUser
            ..content = entity.content
            ..attachment = entity.attachment
            ..attachmentType = entity.attachmentType
            ..dateContent = entity.dateContent);

  ReportContents toEntity() => ReportContents()
    ..id = this.id
    ..numReport = this.numReport
    ..typeUser = this.typeUser
    ..content = this.content
    ..attachment = this.attachment
    ..attachmentType = this.attachmentType
    ..dateContent = this.dateContent;
}
