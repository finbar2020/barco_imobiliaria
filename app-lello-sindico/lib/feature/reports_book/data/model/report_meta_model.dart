import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/meta.dart';

part 'report_meta_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReportMetaModel {
  int? currentPage;
  int? totalPage;
  int? itemCount;
  int? itemsPerPage;
  int? totalItems;

  ReportMetaModel({
    this.currentPage,
    this.totalPage,
    this.itemCount,
    this.itemsPerPage,
    this.totalItems,
  });

  factory ReportMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ReportMetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportMetaModelToJson(this);

  static ReportMetaModel? fromEntity(Meta? entity) => entity == null
      ? null
      : (ReportMetaModel()
        ..currentPage = entity.currentPage
        ..totalPage = entity.totalPage
        ..itemCount = entity.itemCount
        ..itemsPerPage = entity.itemsPerPage
        ..totalItems = entity.totalItems);

  Meta toEntity() => Meta()
    ..currentPage = this.currentPage
    ..totalPage = this.totalPage
    ..itemCount = this.itemCount
    ..itemsPerPage = this.itemsPerPage
    ..totalItems = this.totalItems;
}
