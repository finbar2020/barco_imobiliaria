import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

part 'space_available_hours_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceAvailableHoursModel {
  String? from;
  String? until;

  SpaceAvailableHoursModel();

  factory SpaceAvailableHoursModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceAvailableHoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceAvailableHoursModelToJson(this);

  static SpaceAvailableHoursModel? fromEntity(SpaceAvailableHours? entity) =>
      entity == null ? null : (SpaceAvailableHoursModel()..from);

  SpaceAvailableHours toEntity() => SpaceAvailableHours()
    ..from = this.from
    ..until = this.until;
}
