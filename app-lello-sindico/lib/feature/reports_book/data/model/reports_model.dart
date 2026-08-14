import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/reports_book/data/model/report_meta_model.dart';
import 'package:lello/feature/reports_book/data/model/report_model.dart';

import '../../domain/entity/reports.dart';

part 'reports_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportsModel {
  ReportMetaModel? meta;
  List<ReportModel>? data;

  ReportsModel({
    this.meta,
    this.data,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) =>
      _$ReportsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportsModelToJson(this);

  static ReportsModel? fromEntity(Reports? entity) => entity == null
      ? null
      : (ReportsModel()
        ..meta = ReportMetaModel.fromEntity(entity.meta)
        ..data = entity.report
                ?.map((value) => ReportModel.fromEntity(value)!)
                .toList() ??
            []);

  Reports toEntity() => Reports()
    ..meta = meta?.toEntity()
    ..report = data?.map((e) => e.toEntity()).toList() ?? [];
}
