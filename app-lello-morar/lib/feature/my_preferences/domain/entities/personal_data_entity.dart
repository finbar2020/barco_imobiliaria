import 'package:essentials/essentials.dart';

class PersonalDataEntity {
  final String cpf;

  PersonalDataEntity({
    required this.cpf,
  });

  PersonalDataEntity copyWith({String? cpf}) => PersonalDataEntity(
        cpf: cpf ?? this.cpf,
      );

  factory PersonalDataEntity.fromJson(Map<String, dynamic> json) {
    return PersonalDataEntity(
      cpf: json['cpf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
    };
  }
}
