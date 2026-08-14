import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_condo_location_entity.dart';

part 'timesheet_condo_location_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondoLocationModel {
  final String reference;
  final double latitude;
  final double longitude;
  CondoLocationModel({
    this.reference = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  factory CondoLocationModel.fromJson(Map<String, dynamic> json) =>
      _$CondoLocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CondoLocationModelToJson(this);

  static CondoLocationModel? fromEntity(CondoLocationEntity? entity) =>
      entity == null
          ? null
          : (CondoLocationModel(
              reference: entity.reference,
              latitude: entity.latitude,
              longitude: entity.longitude,
            ));

  CondoLocationEntity toEntity() => CondoLocationEntity(
        reference: reference,
        latitude: latitude,
        longitude: longitude,
      );
}
