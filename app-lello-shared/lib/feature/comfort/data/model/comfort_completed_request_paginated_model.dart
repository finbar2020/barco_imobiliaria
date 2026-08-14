import 'package:essentials/essentials.dart';
import 'package:essentials/paginator/meta.dart';
import 'package:essentials/paginator/meta_model.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_completed_request_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';

part 'comfort_completed_request_paginated_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortCompletedRequestPaginatedModel {
  MetaModel? meta;
  List<ComfortCompletedRequestModel>? data;

  ComfortCompletedRequestPaginatedModel({
    this.meta,
    this.data,
  });

  factory ComfortCompletedRequestPaginatedModel.fromJson(
          Map<String, dynamic> json) =>
      _$ComfortCompletedRequestPaginatedModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ComfortCompletedRequestPaginatedModelToJson(this);

  static ComfortCompletedRequestPaginatedModel? fromEntity(
          ComfortCompletedRequestPaginated? entity) =>
      entity == null
          ? null
          : (ComfortCompletedRequestPaginatedModel()
            ..meta = MetaModel.fromEntity(entity.meta)
            ..data = entity.data.isEmpty
                ? []
                : entity.data
                    .map((e) => ComfortCompletedRequestModel.fromEntity(e)!)
                    .toList());

  ComfortCompletedRequestPaginated toEntity() =>
      ComfortCompletedRequestPaginated(
        meta: this.meta?.toEntity() ?? Meta(),
        data: this.data == null || this.data!.isEmpty
            ? []
            : this.data!.map((e) => e.toEntity()).toList(),
      );
}
