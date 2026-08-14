import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';

part 'space_available_hours_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceAvailableHoursModel {
  String from;
  String until;

  SpaceAvailableHoursModel({
    required this.from,
    required this.until,
  });

  factory SpaceAvailableHoursModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceAvailableHoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceAvailableHoursModelToJson(this);

  static SpaceAvailableHoursModel? fromEntity(SpaceAvailableHours? entity) =>
      entity == null
          ? null
          : (SpaceAvailableHoursModel(from: entity.from, until: entity.until));

  SpaceAvailableHours toEntity() =>
      SpaceAvailableHours(from: this.from, until: this.until);
}
