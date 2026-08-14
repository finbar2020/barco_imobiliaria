import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/reports_book/domain/entity/report_filter.dart';

part 'report_filter_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportFilterModel {
  DateTime? dateFrom;
  DateTime? dateTo;
  int? type;
  bool? closed;
  String? unitId;
  bool showOnlyNewReports;
  bool showOnlyReplies;

  ReportFilterModel({
    this.dateFrom,
    this.dateTo,
    this.type,
    this.closed,
    this.unitId,
    this.showOnlyNewReports = false,
    this.showOnlyReplies = false,
  });

  factory ReportFilterModel.fromJson(Map<String, dynamic> json) =>
      _$ReportFilterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportFilterModelToJson(this);

  static ReportFilterModel? fromEntity(ReportFilter? entity) => entity == null
      ? null
      : (ReportFilterModel()
        ..dateFrom = entity.dateFrom
        ..dateTo = entity.dateTo
        ..type = entity.type
        ..closed = entity.closed
        ..unitId = entity.unitId
        ..showOnlyNewReports = entity.showOnlyNewReports
        ..showOnlyReplies = entity.showOnlyReplies);

  ReportFilter toEntity() => ReportFilter()
    ..dateFrom = this.dateFrom
    ..dateTo = this.dateTo
    ..type = this.type
    ..closed = this.closed
    ..unitId = this.unitId
    ..showOnlyNewReports = this.showOnlyNewReports
    ..showOnlyReplies = this.showOnlyReplies;
}
