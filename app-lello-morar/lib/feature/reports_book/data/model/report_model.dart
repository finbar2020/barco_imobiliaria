import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reports_book/data/model/report_contents_model.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';

part 'report_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportModel {
  String? idReport;
  String? typeReport;
  DateTime? dateReport;
  List<ReportContentsModel?>? reportContents;
  bool? closed;
  bool? newMessage;
  String? numReport;
  String? notificationParameter;
  bool? public;

  ReportModel({
    this.idReport,
    this.typeReport,
    this.dateReport,
    this.reportContents,
    this.closed,
    this.newMessage,
    this.numReport,
    this.notificationParameter,
    this.public,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  static ReportModel? fromEntity(Report? entity) => entity == null
      ? null
      : (ReportModel()
        ..idReport = entity.idReport
        ..typeReport = entity.typeReport
        ..dateReport = entity.dateReport
        ..public = entity.public
        ..reportContents = entity.reportContents
                ?.map((value) => ReportContentsModel.fromEntity(value))
                .toList() ??
            []
        ..closed = entity.closed
        ..newMessage = entity.newMessage
        ..numReport = entity.numReport
        ..notificationParameter = entity.notificationParameter);

  Report toEntity() => Report()
    ..idReport = this.idReport
    ..typeReport = this.typeReport
    ..dateReport = this.dateReport
    ..reportContents =
        this.reportContents?.map((e) => e!.toEntity()).toList() ?? []
    ..closed = this.closed
    ..newMessage = this.newMessage
    ..numReport = this.numReport
    ..public = this.public ?? true
    ..notificationParameter = this.notificationParameter;
}
