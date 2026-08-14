import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reports_book/domain/entity/report_create.dart';

part 'report_create_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportCreateModel {
  String? idUnit;
  String? typeReport;
  DateTime? dateReport;
  String? content;
  bool? public;

  ReportCreateModel({
    this.idUnit,
    this.typeReport,
    this.dateReport,
    this.content,
    this.public,
  });

  factory ReportCreateModel.fromJson(Map<String, dynamic> json) =>
      _$ReportCreateModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportCreateModelToJson(this);

  static ReportCreateModel? fromEntity(ReportCreate? entity) => entity == null
      ? null
      : (ReportCreateModel()
        ..idUnit = entity.idUnit
        ..typeReport = entity.typeReport
        ..dateReport = entity.dateReport
        ..content = entity.content
        ..public = entity.public);

  ReportCreate toEntity() => ReportCreate()
    ..idUnit = this.idUnit
    ..typeReport = this.typeReport
    ..dateReport = this.dateReport
    ..content = this.content
    ..public = this.public;

  @override
  String toString() {
    return 'ReportCreateModel(idUnit: $idUnit, typeReport: $typeReport, dateReport: $dateReport, content: $content)';
  }
}
