import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_param.dart';

part 'tdb_param_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TDBParamModel {
  String type;
  String nameParam;
  String param;

  TDBParamModel({
    this.type = "",
    this.nameParam = "",
    this.param = "",
  });

  factory TDBParamModel.fromJson(Map<String, dynamic> json) =>
      _$TDBParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TDBParamModelToJson(this);

  static TDBParamModel? fromEntity(TDBParam? entity) => entity == null
      ? null
      : (TDBParamModel()
        ..type = entity.type
        ..nameParam = entity.nameParam
        ..param = entity.param);

  TDBParam toEntity() => TDBParam(
        type: this.type,
        nameParam: this.nameParam,
        param: this.param,
      );
}
