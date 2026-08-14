class GeographicCoordinates {
  final String longitude;
  final String latitude;

  double? get longitudeDouble =>
      longitude.isEmpty ? null : double.tryParse(longitude);
  double? get latitudeDouble =>
      latitude.isEmpty ? null : double.tryParse(latitude);

  GeographicCoordinates({
    required this.longitude,
    required this.latitude,
  });

  factory GeographicCoordinates.clone(
          GeographicCoordinates geographicCoordinates) =>
      GeographicCoordinates(
        longitude: geographicCoordinates.longitude,
        latitude: geographicCoordinates.latitude,
      );
}
