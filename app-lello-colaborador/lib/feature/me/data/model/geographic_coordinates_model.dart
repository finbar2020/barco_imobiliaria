import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geographic_coordinates_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GeographicCoordinatesModel {
  String longitude;
  String latitude;

  GeographicCoordinatesModel({required this.longitude, required this.latitude});

  factory GeographicCoordinatesModel.fromJson(Map<String, dynamic> json) =>
      _$GeographicCoordinatesModelFromJson(json);
  Map<String, dynamic> toJson() => _$GeographicCoordinatesModelToJson(this);

  static GeographicCoordinatesModel? fromEntity(
          GeographicCoordinates? geographicCoordinates) =>
      geographicCoordinates == null
          ? null
          : (GeographicCoordinatesModel(
              longitude: geographicCoordinates.longitude,
              latitude: geographicCoordinates.latitude,
            ));

  GeographicCoordinates toEntity() => GeographicCoordinates(
        longitude: longitude,
        latitude: latitude,
      );
}
