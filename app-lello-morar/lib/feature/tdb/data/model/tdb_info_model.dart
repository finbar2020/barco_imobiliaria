import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/tdb/data/model/tdb_param_model.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';

part 'tdb_info_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TDBInfoModel {
  String redirectLink;
  List<TDBParamModel?> information;

  TDBInfoModel({
    this.redirectLink = "",
    this.information = const [],
  });

  factory TDBInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TDBInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TDBInfoModelToJson(this);

  static TDBInfoModel? fromEntity(TDBInfo? entity) => entity == null
      ? null
      : (TDBInfoModel()
        ..redirectLink = entity.redirectLink
        ..information = entity.information.isEmpty
            ? []
            : entity.information
                .map((e) => TDBParamModel.fromEntity(e))
                .toList());

  TDBInfo toEntity() => TDBInfo(
      redirectLink: this.redirectLink,
      information: this.information.isEmpty
          ? []
          : this.information.map((e) => e?.toEntity()).toList());
}
