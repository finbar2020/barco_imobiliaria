import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/data/model/access_control_date_model.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_itens.dart';

part 'access_control_itens_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlItensModel {
  int? recurrenceValue;
  AccessControlDateModel? start;
  AccessControlDateModel? end;

  AccessControlItensModel({this.recurrenceValue, this.start, this.end});

  factory AccessControlItensModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlItensModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlItensModelToJson(this);

  static AccessControlItensModel? fromEntity(AccessControlItens? entity) =>
      entity == null
          ? null
          : (AccessControlItensModel()
            ..recurrenceValue = entity.recurrenceValue
            ..start = AccessControlDateModel.fromEntity(entity.start)
            ..end = AccessControlDateModel.fromEntity(entity.end));

  AccessControlItens toEntity() => AccessControlItens()
    ..recurrenceValue = recurrenceValue
    ..start = start?.toEntity()
    ..end = end?.toEntity();
}
