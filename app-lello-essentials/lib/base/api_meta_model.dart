import 'package:essentials/base/api_meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_meta_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiMetaModel {
  int? currentPage;
  int? totalPages;
  int? itemCount;
  int? itemsPerPage;
  int? totalItems;

  ApiMetaModel({
    required this.currentPage,
    required this.totalPages,
    required this.itemCount,
    required this.itemsPerPage,
    required this.totalItems,
  });

  factory ApiMetaModel.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiMetaModelToJson(this);

  static ApiMetaModel fromEntity(ApiMeta entity) => ApiMetaModel(
        currentPage: entity.currentPage,
        totalPages: entity.totalPages,
        itemCount: entity.itemCount,
        itemsPerPage: entity.itemsPerPage,
        totalItems: entity.totalItems,
      );

  ApiMeta toEntity() => ApiMeta(
        currentPage: this.currentPage ?? 0,
        totalPages: this.totalPages ?? 0,
        itemCount: this.itemCount ?? 0,
        itemsPerPage: this.itemsPerPage ?? 0,
        totalItems: this.totalItems ?? 0,
      );
}
