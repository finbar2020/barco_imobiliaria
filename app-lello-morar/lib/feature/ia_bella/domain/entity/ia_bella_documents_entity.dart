class IaBellaDocumentsEntity {
  final String? id;
  final String? description;
  final String? serviceType;

  IaBellaDocumentsEntity({
    this.id,
    this.description,
    this.serviceType,
  });

  IaBellaDocumentsEntity copyWith({
    String? id,
    String? description,
    String? serviceType,
  }) {
    return IaBellaDocumentsEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      serviceType: serviceType ?? this.serviceType,
    );
  }
}
