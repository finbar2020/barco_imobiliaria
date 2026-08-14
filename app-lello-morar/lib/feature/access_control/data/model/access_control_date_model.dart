import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_date.dart';

part 'access_control_date_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlDateModel {
  int? hour;
  int? minute;
  int? aecond;
  int? nano;

  AccessControlDateModel({
    this.hour,
    this.minute,
    this.aecond,
    this.nano,
  });

  factory AccessControlDateModel.fromJson(Map<String, dynamic> json) =>
      _$AccessControlDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccessControlDateModelToJson(this);

  static AccessControlDateModel? fromEntity(AccessControlDate? entity) =>
      entity == null
          ? null
          : (AccessControlDateModel()
            ..hour = entity.hour
            ..minute = entity.minute
            ..aecond = entity.aecond
            ..nano = entity.nano);

  AccessControlDate toEntity() => AccessControlDate()
    ..hour = this.hour
    ..minute = this.minute
    ..aecond = this.aecond
    ..nano = this.nano;
}
