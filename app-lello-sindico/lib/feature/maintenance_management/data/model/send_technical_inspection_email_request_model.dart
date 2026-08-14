class SendTechnicalInspectionEmailRequestModel {
  final String type;
  final String id;
  final String email;

  const SendTechnicalInspectionEmailRequestModel({
    required this.type,
    required this.id,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'email': email,
      };
}
