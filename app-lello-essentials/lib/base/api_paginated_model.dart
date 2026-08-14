// part 'api_paginated_model.g.dart';

//TODO: Pensar em uma forma de deixar generico a criação de ApiPaginatedModel
// @JsonSerializable(fieldRename: FieldRename.snake)
class ApiPaginatedModel<Data> {
  // ApiMetaModel meta;
  // Data data;

  // ApiPaginatedModel({
  //   required this.meta,
  //   required this.data,
  // });

  // factory ApiPaginatedModel.fromJson(Map<String, dynamic> json) =>
  //     _$ApiPaginatedModelFromJson(json);
  // Map<String, dynamic> toJson() => _$ApiPaginatedModelToJson(this);

  // ApiPaginated toEntity() =>
  //     ApiPaginated(data: this.data, meta: this.meta.toEntity());
}
