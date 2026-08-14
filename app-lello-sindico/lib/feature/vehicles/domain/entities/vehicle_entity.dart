class Vehicle {
  final String id;
  final String type;
  final String? identificationNumber;
  final String? model;
  final String? color;
  final String idUnity;
  final bool rentedSpace;

  Vehicle({
    required this.id,
    required this.type,
    this.identificationNumber,
    this.model,
    this.color,
    required this.idUnity,
    required this.rentedSpace,
  });
}
