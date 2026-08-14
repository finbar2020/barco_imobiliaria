import 'package:essentials/paginator/meta_model.dart';
import 'package:essentials/paginator/paginator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginator_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatorModel {
  MetaModel? meta;
  dynamic data;

  PaginatorModel({
    this.meta,
    this.data,
  });

  factory PaginatorModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatorModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatorModelToJson(this);

  static PaginatorModel? fromEntity(Paginator? entity) => entity == null
      ? null
      : (PaginatorModel()
        ..meta = MetaModel.fromEntity(entity.meta)
        ..data = entity.data);

  Paginator toEntity() => Paginator()
    ..meta = this.meta?.toEntity()
    ..data = this.data;
}
