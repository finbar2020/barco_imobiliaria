import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/consultant_lello/domain/entity/consultant_lello.dart';

part 'consultant_lello_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ConsultantModel {
  String? number;

  ConsultantModel();

  factory ConsultantModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultantModelFromJson(json);
  Map<String, dynamic> toJson() => _$ConsultantModelToJson(this);

  static ConsultantModel? fromEntity(ConsultantEntity? entity) => entity != null
      ? (ConsultantModel()
        ..number = entity.number)
      : null;

  ConsultantEntity toEntity() => ConsultantEntity()
    ..number = this.number;
}
