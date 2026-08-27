import 'package:essentials/essentials.dart';

class UnitContactDataEntity {
  final String correspondenceEmail;
  final String careEmail;
  final String careName;
  final bool useContactEmail;

  UnitContactDataEntity({
    required this.correspondenceEmail,
    required this.careEmail,
    required this.careName,
    required this.useContactEmail,
  });

  UnitContactDataEntity copyWith(
          {String? correspondenceEmail,
          String? careEmail,
          String? careName,
          bool? useContactEmail}) =>
      UnitContactDataEntity(
        correspondenceEmail: correspondenceEmail ?? this.correspondenceEmail,
        careEmail: careEmail ?? this.careEmail,
        careName: careName ?? this.careName,
        useContactEmail: useContactEmail ?? this.useContactEmail,
      );

  factory UnitContactDataEntity.fromJson(Map<String, dynamic> json) {
    return UnitContactDataEntity(
      correspondenceEmail: json['emailCorrespondencia'] ?? '',
      careEmail: json['emailAosCuidados'] ?? '',
      careName: json['nomeAosCuidados'] ?? '',
      useContactEmail: json['usarEmailContato'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailCorrespondencia': correspondenceEmail,
      'emailAosCuidados': careEmail,
      'nomeAosCuidados': careName,
      'usarEmailContato': useContactEmail,
    };
  }
}
