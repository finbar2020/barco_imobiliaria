import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/reports_book/data/model/report_contents_model.dart';
import 'package:lello/feature/reports_book/data/model/unit_model.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';

part 'report_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportModel {
  String? idReport;
  UnitModel? unit;
  String? typeReport;
  DateTime? dateReport;
  List<ReportContentsModel>? reportContents;
  bool? closed;
  bool? newMessage;
  bool? isPublic;
  String? numReport;
  String? notificationParameter;

  ReportModel({
    this.idReport,
    this.unit,
    this.typeReport,
    this.dateReport,
    this.reportContents,
    this.isPublic,
    this.closed,
    this.newMessage,
    this.numReport,
    this.notificationParameter,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  static ReportModel? fromEntity(Report? entity) => entity == null
      ? null
      : (ReportModel()
        ..idReport = entity.idReport
        ..typeReport = entity.typeReport
        ..unit = UnitModel.fromEntity(entity.unit)
        ..dateReport = entity.dateReport
        ..reportContents = entity.reportContents
                ?.map((value) => ReportContentsModel.fromEntity(value)!)
                .toList() ??
            []
        ..closed = entity.closed
        ..isPublic = entity.isPublic
        ..newMessage = entity.newMessage
        ..numReport = entity.numReport
        ..notificationParameter = entity.notificationParameter);

  Report toEntity() => Report()
    ..idReport = this.idReport
    ..typeReport = this.typeReport
    ..unit = this.unit?.toEntity()
    ..dateReport = this.dateReport
    ..reportContents =
        this.reportContents?.map((e) => e.toEntity()).toList() ?? []
    ..closed = this.closed ?? false
    ..isPublic = this.isPublic ?? false
    ..newMessage = this.newMessage ?? false
    ..numReport = this.numReport
    ..notificationParameter = this.notificationParameter;
}
