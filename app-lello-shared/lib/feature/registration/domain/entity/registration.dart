// ignore_for_file: public_member_api_docs, sort_constructors_first
part of shared_features;

class Registration {
  final String? name;
  final String? cpf;
  final String? email;
  final String? phone;
  final String? codeValidationId;
  final String? password;
  final bool? termsAndConditionsCheck;
  final File? profilePicture;
  final bool? registeredError;
  final String? token;
  final int? idEmpresa;

  Registration({
    this.name,
    this.cpf,
    this.email,
    this.phone,
    this.codeValidationId,
    this.password,
    this.termsAndConditionsCheck,
    this.profilePicture,
    this.registeredError,
    this.token,
    this.idEmpresa,
  });

  Registration copyWith({
    String? name,
    String? cpf,
    String? email,
    String? phone,
    String? codeValidationId,
    String? password,
    bool? termsAndConditionsCheck,
    File? profilePicture,
    bool? registeredError,
    String? token,
    int? idEmpresa,
  }) {
    return Registration(
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      codeValidationId: codeValidationId ?? this.codeValidationId,
      password: password ?? this.password,
      termsAndConditionsCheck:
          termsAndConditionsCheck ?? this.termsAndConditionsCheck,
      profilePicture: profilePicture ?? this.profilePicture,
      registeredError: registeredError ?? this.registeredError,
      token: token ?? this.token,
      idEmpresa: idEmpresa ?? this.idEmpresa,
    );
  }
}
