import 'package:essentials/paginator/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta_model.g.dart';

@JsonSerializable()
class MetaModel {
  int? currentPage;
  int? totalPages;
  int? itemCount;
  int? itemPerPage;
  int? totalItems;

  MetaModel({
    this.currentPage,
    this.totalPages,
    this.itemCount,
    this.itemPerPage,
    this.totalItems,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MetaModelToJson(this);

  static MetaModel? fromEntity(Meta? entity) => entity == null
      ? null
      : (MetaModel()
        ..currentPage = entity.currentPage
        ..totalPages = entity.totalPages
        ..itemCount = entity.itemCount
        ..itemPerPage = entity.itemPerPage
        ..totalItems = entity.totalItems);

  Meta toEntity() => Meta()
    ..currentPage = this.currentPage
    ..totalPages = this.totalPages
    ..itemCount = this.itemCount
    ..itemPerPage = this.itemPerPage
    ..totalItems = this.totalItems;

  @override
  String toString() {
    return 'MetaModel(currentPage: $currentPage, totalPages: $totalPages, itemCount: $itemCount, itemPerPage: $itemPerPage, totalItems: $totalItems)';
  }
}
